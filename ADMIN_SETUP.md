# 🔐 Admin Credentials Setup

## **Available User Accounts:**

I found 4 existing user accounts in your Firebase project:

1. **imshailesharma@gmail.com** (Shailesh)
   - UID: `9RuYdeHrCsUC0ebCSL47xgqqSS63`

2. **technos52h@gmail.com** (Technos 52) 
   - UID: `c1KEyBgDJFhwhiz6hZe1uOvU1Da2`

3. **founder.edem@gmail.com** (Founder Edem)
   - UID: `dTNUn4IryIc7KS3Uia6mcpgpqmU2`

4. **shailokesh1@gmail.com** (Gotam jha)
   - UID: `fhwMM22i6tRj3d81vXTrAqd5Pm62`

---

## **🚀 Quick Setup - Choose Your Admin Account:**

### **Option 1: Make `technos52h@gmail.com` Admin (Recommended)**
```bash
# Run this in your terminal:
firebase firestore:write admins/c1KEyBgDJFhwhiz6hZe1uOvU1Da2 '{"isAdmin":true,"email":"technos52h@gmail.com","promotedAt":{"_seconds":1731757200,"_nanoseconds":0}}'
```

### **Option 2: Make `imshailesharma@gmail.com` Admin**
```bash
# Run this in your terminal:
firebase firestore:write admins/9RuYdeHrCsUC0ebCSL47xgqqSS63 '{"isAdmin":true,"email":"imshailesharma@gmail.com","promotedAt":{"_seconds":1731757200,"_nanoseconds":0}}'
```

---

## **📝 Manual Setup (Alternative):**

1. **Go to Firestore Console**: https://console.firebase.google.com/project/jobease-edevs/firestore
2. **Create Collection**: `admins`
3. **Add Document** with one of these UIDs as Document ID:
   - Document ID: `c1KEyBgDJFhwhiz6hZe1uOvU1Da2` (for technos52h@gmail.com)
   - Fields:
     - `isAdmin`: `true` (boolean)
     - `email`: `technos52h@gmail.com` (string)
     - `promotedAt`: Current timestamp

---

## **🔓 Your Admin Login Credentials:**

After setting up admin access above, you can login with:

**URL**: https://jobease-52.web.app
**Email**: `technos52h@gmail.com` (or whichever account you chose)
**Password**: [Your existing Google account - use "Sign in with Google"]

---

## **⚡ Quick One-Click Setup:**

I'll set up `technos52h@gmail.com` as admin for you right now!