// set-admin-claim.js
// Firebase Admin SDK를 사용하여 특정 사용자에게 관리자 권한 부여

const admin = require('firebase-admin');

// ============================================
// 1. Service Account Key 파일 경로 설정
// ============================================
// Firebase Console에서 다운로드한 serviceAccountKey.json 파일 경로
const serviceAccount = require('./serviceAccountKey.json');

// ============================================
// 2. Firebase Admin SDK 초기화
// ============================================
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

// ============================================
// 3. 관리자로 설정할 이메일 주소
// ============================================
const ADMIN_EMAIL = 'iconoding.dev@gmail.com'; // 여기에 관리자 이메일 입력

// ============================================
// 4. Custom Claims 설정 함수
// ============================================
async function setAdminClaim() {
  try {
    console.log('🔍 사용자 검색 중...');

    // 이메일로 사용자 찾기
    const user = await admin.auth().getUserByEmail(ADMIN_EMAIL);

    console.log(`✅ 사용자 찾음: ${user.email}`);
    console.log(`   UID: ${user.uid}`);

    // Custom Claims 설정 (admin: true)
    await admin.auth().setCustomUserClaims(user.uid, {
      admin: true
    });

    console.log('🎉 성공! 관리자 권한이 부여되었습니다.');
    console.log(`   ${user.email}은(는) 이제 관리자입니다.`);

    // 확인: Custom Claims 읽어오기
    const updatedUser = await admin.auth().getUser(user.uid);
    console.log('📋 현재 Custom Claims:', updatedUser.customClaims);

    process.exit(0);
  } catch (error) {
    console.error('❌ 오류 발생:', error.message);

    if (error.code === 'auth/user-not-found') {
      console.error('💡 힌트: Firebase Authentication에 해당 사용자가 없습니다.');
      console.error('   Firebase Console > Authentication > Users에서 먼저 사용자를 생성하세요.');
    }

    process.exit(1);
  }
}

// 실행
console.log('🚀 관리자 권한 설정 시작...');
console.log(`📧 대상 이메일: ${ADMIN_EMAIL}`);
console.log('');

setAdminClaim();