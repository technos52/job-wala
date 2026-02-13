# Manual Dropdown Setup Guide

Since the automated scripts are encountering interactive prompts, here's how to manually set up the dropdown data in Firebase:

## Option 1: Firebase Console (Recommended)

### Step 1: Go to Firebase Console
1. Open [Firebase Console](https://console.firebase.google.com/)
2. Select your project: `jobease-edevs`
3. Go to **Firestore Database**

### Step 2: Create dropdown_options Collection
1. Click **"Start collection"**
2. Collection ID: `dropdown_options`
3. Click **"Next"**

### Step 3: Create Documents
Create these documents with the exact IDs and data:

#### Document ID: `qualification`
```json
{
  "options": [
    "High School",
    "Diploma", 
    "Bachelor's Degree",
    "Master's Degree",
    "PhD",
    "Certificate Course",
    "Professional Certification"
  ],
  "created_at": "2025-01-20T10:00:00Z",
  "updated_at": "2025-01-20T10:00:00Z"
}
```

#### Document ID: `jobCategory`
```json
{
  "options": [
    "Software Development",
    "Marketing & Sales", 
    "Human Resources",
    "Finance & Accounting",
    "Operations",
    "Customer Service",
    "Design & Creative",
    "Data Science & Analytics",
    "Project Management",
    "Quality Assurance",
    "Business Development",
    "Administration"
  ],
  "created_at": "2025-01-20T10:00:00Z",
  "updated_at": "2025-01-20T10:00:00Z"
}
```

#### Document ID: `jobType`
```json
{
  "options": [
    "Full Time",
    "Part Time", 
    "Contract",
    "Internship",
    "Freelance",
    "Remote",
    "Hybrid"
  ],
  "created_at": "2025-01-20T10:00:00Z",
  "updated_at": "2025-01-20T10:00:00Z"
}
```

#### Document ID: `designation`
```json
{
  "options": [
    "Software Engineer",
    "Senior Software Engineer",
    "Team Lead",
    "Project Manager", 
    "Business Analyst",
    "Marketing Executive",
    "Sales Executive",
    "HR Executive",
    "Finance Executive",
    "Operations Executive",
    "Customer Support Executive",
    "Quality Analyst",
    "Data Analyst",
    "UI/UX Designer",
    "Product Manager"
  ],
  "created_at": "2025-01-20T10:00:00Z",
  "updated_at": "2025-01-20T10:00:00Z"
}
```

#### Document ID: `companyType`
```json
{
  "options": [
    "Information Technology (IT)",
    "Banking & Finance",
    "Healthcare & Pharmaceuticals", 
    "Education & Training",
    "Manufacturing",
    "Retail & E-commerce",
    "Consulting",
    "Real Estate",
    "Automotive",
    "Telecommunications",
    "Media & Entertainment",
    "Food & Beverage",
    "Government",
    "Non-Profit",
    "Startup",
    "Other"
  ],
  "created_at": "2025-01-20T10:00:00Z",
  "updated_at": "2025-01-20T10:00:00Z"
}
```

#### Document ID: `location`
```json
{
  "options": [
    "Mumbai",
    "Delhi",
    "Bangalore",
    "Chennai",
    "Hyderabad",
    "Pune",
    "Kolkata",
    "Ahmedabad",
    "Surat",
    "Jaipur",
    "Lucknow",
    "Kanpur",
    "Nagpur",
    "Indore",
    "Thane",
    "Bhopal",
    "Visakhapatnam",
    "Pimpri-Chinchwad",
    "Patna",
    "Vadodara"
  ],
  "created_at": "2025-01-20T10:00:00Z",
  "updated_at": "2025-01-20T10:00:00Z"
}
```

## Option 2: Import JSON (Faster)

If Firebase Console allows JSON import:

1. Create a file `dropdown_data.json`:
```json
{
  "dropdown_options": {
    "qualification": {
      "options": ["High School", "Diploma", "Bachelor's Degree", "Master's Degree", "PhD", "Certificate Course", "Professional Certification"]
    },
    "jobCategory": {
      "options": ["Software Development", "Marketing & Sales", "Human Resources", "Finance & Accounting", "Operations", "Customer Service", "Design & Creative", "Data Science & Analytics", "Project Management", "Quality Assurance", "Business Development", "Administration"]
    },
    "jobType": {
      "options": ["Full Time", "Part Time", "Contract", "Internship", "Freelance", "Remote", "Hybrid"]
    },
    "designation": {
      "options": ["Software Engineer", "Senior Software Engineer", "Team Lead", "Project Manager", "Business Analyst", "Marketing Executive", "Sales Executive", "HR Executive", "Finance Executive", "Operations Executive", "Customer Support Executive", "Quality Analyst", "Data Analyst", "UI/UX Designer", "Product Manager"]
    },
    "companyType": {
      "options": ["Information Technology (IT)", "Banking & Finance", "Healthcare & Pharmaceuticals", "Education & Training", "Manufacturing", "Retail & E-commerce", "Consulting", "Real Estate", "Automotive", "Telecommunications", "Media & Entertainment", "Food & Beverage", "Government", "Non-Profit", "Startup", "Other"]
    },
    "location": {
      "options": ["Mumbai", "Delhi", "Bangalore", "Chennai", "Hyderabad", "Pune", "Kolkata", "Ahmedabad", "Surat", "Jaipur", "Lucknow", "Kanpur", "Nagpur", "Indore", "Thane", "Bhopal", "Visakhapatnam", "Pimpri-Chinchwad", "Patna", "Vadodara"]
    }
  }
}
```

2. Import this JSON into Firestore

## Verification

After setting up the data:

1. **Restart your Flutter app**
2. **Check registration forms** - all dropdowns should now have data
3. **Check dashboard filters** - should show proper options
4. **Check job category tabs** - should show actual categories

## Expected Results

✅ **Registration Step 2**: All dropdowns (qualification, job category, job type, designation, company type) should be populated
✅ **Dashboard**: Job category tabs should show actual categories instead of just "All Jobs"  
✅ **Dashboard Filters**: All filter dropdowns should have proper options
✅ **No more empty dropdowns**: All dropdowns should fall back to default values if Firebase fails

## Troubleshooting

If dropdowns are still empty after setup:
1. Check Firestore security rules allow reads
2. Verify document structure has `options` field (array)
3. Check app logs for Firebase connection errors
4. Restart the app completely