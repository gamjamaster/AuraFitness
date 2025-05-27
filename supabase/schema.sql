-- 사용자 인증 테이블 (Supabase Auth에서 자동 생성)

-- 트레이너 테이블
CREATE TABLE trainers (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    name TEXT NOT NULL,
    specialization TEXT NOT NULL,
    experience_years INTEGER NOT NULL,
    bio TEXT,
    image_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- 수업 테이블
CREATE TABLE classes (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT NOT NULL,
    trainer_id UUID REFERENCES trainers(id),
    capacity INTEGER NOT NULL,
    duration_minutes INTEGER NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    schedule JSONB NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- 예약 테이블
CREATE TABLE bookings (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id),
    class_id UUID REFERENCES classes(id),
    booking_date TIMESTAMP WITH TIME ZONE NOT NULL,
    status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'cancelled')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- 리뷰 테이블
CREATE TABLE reviews (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id),
    trainer_id UUID REFERENCES trainers(id),
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- 문의 테이블
CREATE TABLE contacts (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT NOT NULL,
    message TEXT NOT NULL,
    status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'replied')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- RLS (Row Level Security) 정책 설정
ALTER TABLE trainers ENABLE ROW LEVEL SECURITY;
ALTER TABLE classes ENABLE ROW LEVEL SECURITY;
ALTER TABLE bookings ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE contacts ENABLE ROW LEVEL SECURITY;

-- 트레이너 테이블 정책
CREATE POLICY "트레이너 정보는 모든 사용자가 조회 가능" ON trainers
    FOR SELECT USING (true);

-- 수업 테이블 정책
CREATE POLICY "수업 정보는 모든 사용자가 조회 가능" ON classes
    FOR SELECT USING (true);

-- 예약 테이블 정책
CREATE POLICY "사용자는 자신의 예약만 조회 가능" ON bookings
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "인증된 사용자만 예약 가능" ON bookings
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- 리뷰 테이블 정책
CREATE POLICY "리뷰는 모든 사용자가 조회 가능" ON reviews
    FOR SELECT USING (true);

CREATE POLICY "인증된 사용자만 리뷰 작성 가능" ON reviews
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- 문의 테이블 정책
CREATE POLICY "관리자만 문의 조회 가능" ON contacts
    FOR SELECT USING (auth.uid() IN (
        SELECT id FROM auth.users WHERE email = 'admin@example.com'
    ));

CREATE POLICY "모든 사용자가 문의 작성 가능" ON contacts
    FOR INSERT WITH CHECK (true); 