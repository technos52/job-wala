const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccountKey.json'); // You'll need to download this

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

async function createAdmin() {
  try {
    await db.collection('admins').doc('c1KEyBgDJFhwhiz6hZe1uOvU1Da2').set({
      isAdmin: true,
      email: 'technos52h@gmail.com',
      promotedAt: admin.firestore.FieldValue.serverTimestamp(),
      createdBy: 'firebase-cli',
      role: 'super-admin'
    });
    
    console.log('✅ Admin user created successfully!');
    console.log('📧 Email: technos52h@gmail.com');
    console.log('🆔 UID: c1KEyBgDJFhwhiz6hZe1uOvU1Da2');
    console.log('🔗 Admin Panel: https://jobease-52.web.app');
  } catch (error) {
    console.error('❌ Error creating admin:', error);
  }
  
  process.exit();
}

createAdmin();