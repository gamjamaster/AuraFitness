// 전역 Supabase 클라이언트 초기화
window.supabaseUrl = 'https://jfrxukwkeahtqacohgtj.supabase.co'
window.supabaseKey = 'YOUR_SUPABASE_ANON_KEY'
window.supabaseClient = window.supabase.createClient(window.supabaseUrl, window.supabaseKey)

// 로그인 상태 확인
async function checkAuth() {
    const { data: { user } } = await window.supabaseClient.auth.getUser()
    return user
}

// 로그아웃
async function handleLogout() {
    const { error } = await window.supabaseClient.auth.signOut()
    if (error) {
        console.error('로그아웃 실패:', error.message)
        return
    }
    window.location.href = 'index.html'
}

// 페이지 로드 시 로그인 상태 확인
document.addEventListener('DOMContentLoaded', async () => {
    const user = await checkAuth()
    const loginBtn = document.querySelector('.login-btn')
    
    if (user) {
        // 로그인된 경우
        loginBtn.textContent = '로그아웃'
        loginBtn.onclick = handleLogout
    } else {
        // 로그인되지 않은 경우
        loginBtn.textContent = '로그인'
        loginBtn.href = 'login.html'
    }
})

// 수업 예약 기능
async function bookClass(classId) {
    const { data: { user } } = await window.supabaseClient.auth.getUser()
    if (!user) {
        window.location.href = 'login.html'
        return
    }

    const { data, error } = await window.supabaseClient
        .from('bookings')
        .insert([
            { 
                user_id: user.id,
                class_id: classId,
                booking_date: new Date()
            }
        ])

    if (error) {
        alert('예약 중 오류가 발생했습니다.')
    } else {
        alert('예약이 완료되었습니다!')
    }
}

// 트레이너 리뷰 작성
async function submitReview(trainerId, rating, comment) {
    const { data: { user } } = await window.supabaseClient.auth.getUser()
    if (!user) {
        window.location.href = 'login.html'
        return
    }

    const { data, error } = await window.supabaseClient
        .from('reviews')
        .insert([
            {
                user_id: user.id,
                trainer_id: trainerId,
                rating: rating,
                comment: comment,
                created_at: new Date()
            }
        ])

    if (error) {
        alert('리뷰 작성 중 오류가 발생했습니다.')
    } else {
        alert('리뷰가 등록되었습니다!')
        location.reload()
    }
}

// 문의하기 기능
async function submitContact(name, email, message) {
    const { data, error } = await window.supabaseClient
        .from('contacts')
        .insert([
            {
                name: name,
                email: email,
                message: message,
                created_at: new Date()
            }
        ])

    if (error) {
        alert('문의 전송 중 오류가 발생했습니다.')
    } else {
        alert('문의가 전송되었습니다. 빠른 시일 내에 답변 드리겠습니다.')
        document.querySelector('form').reset()
    }
}

// 회원가입
async function handleRegister(event) {
    event.preventDefault();
    
    const form = event.target;
    const formData = new FormData(form);
    
    const password = formData.get('password');
    const confirmPassword = formData.get('confirmPassword');
    
    if (password !== confirmPassword) {
        alert('비밀번호가 일치하지 않습니다.');
        return;
    }
    
    const { data, error } = await window.supabaseClient.auth.signUp({
        email: formData.get('email'),
        password: password,
        options: {
            data: {
                name: formData.get('name')
            }
        }
    });

    if (error) {
        alert('회원가입에 실패했습니다: ' + error.message);
        return;
    }

    alert('회원가입이 완료되었습니다. 이메일을 확인해주세요.');
    window.location.href = 'login.html';
} 