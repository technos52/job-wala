# Job Application Data Flow Documentation

## When Candidate Clicks "Apply Now"

### 📍 **Where User Details Are Saved**

When a candidate clicks "Apply Now", the application data is saved in **TWO** locations:

#### 1. **Job Applications Collection** (`job_applications`)
**Location**: `FirebaseFirestore.instance.collection('job_applications')`

**Data Saved**:
```dart
{
  'jobId': job['id'],                    // ID of the job being applied to
  'candidateEmail': user.email,          // Candidate's email from Firebase Auth
  'candidateName': _candidateName,       // Candidate's name (loaded from profile)
  'jobTitle': job['jobTitle'],           // Title of the job
  'companyName': job['companyName'],     // Company posting the job
  'appliedAt': FieldValue.serverTimestamp(), // When application was submitted
  'status': 'pending',                   // Application status (pending/approved/rejected)
}
```

#### 2. **Candidate Profile Collection** (`candidates`)
**Location**: `FirebaseFirestore.instance.collection('candidates')`
**Document ID**: Candidate's mobile number (from registration)

**Complete Profile Data Available**:
```dart
{
  // Step 1 Data (Basic Info)
  'fullName': 'John Doe',
  'mobileNumber': '+1234567890',
  'age': 25,
  'gender': 'Male',
  'email': 'john@example.com',
  
  // Step 2 Data (Professional Details)
  'qualification': 'Bachelor\'s Degree (Computer Science)',
  'experienceYears': 3,
  'experienceMonths': 6,
  'jobCategory': 'Information Technology',
  'jobType': 'Full Time',
  'designation': 'Software Engineer',
  'companyName': 'Tech Corp',
  'companyType': 'Private',
  'currentlyWorking': 'yes',
  'noticePeriod': 30,
  
  // Step 3 Data (Personal Details)
  'maritalStatus': 'Single',
  'state': 'California',
  'district': 'San Francisco',
  
  // System Fields
  'emailVerified': true,
  'registrationComplete': true,
  'step': 3,
  'updatedAt': Timestamp,
}
```

### 🔄 **Data Flow Process**

1. **User Authentication**: Firebase Auth provides `user.email` and `user.uid`
2. **Profile Loading**: `_loadCandidateProfile()` retrieves candidate details from `candidates` collection
3. **Application Creation**: When "Apply Now" is clicked, creates document in `job_applications` collection
4. **Employer View**: Employer sees applications via `JobApplicationsScreen` which:
   - Queries `job_applications` by `jobId`
   - Enriches data by looking up full candidate profile from `candidates` collection

### 📊 **What Employers See**

When employers click "View Applications", they see:

**Basic Application Info**:
- Application ID
- Applied date/time
- Application status
- Job title and company

**Candidate Details** (from candidates collection):
- Full name
- Email address
- Phone number
- Age and gender
- Location (district, state)
- Qualification
- Experience (years and months)
- Current designation
- Company type preference
- Job category and type
- Marital status

### 🔍 **Data Sources Priority**

The system loads candidate name in this priority order:
1. **Firebase Auth displayName** (from Google Sign-in)
2. **Firestore candidates collection** (`fullName`, `name`, `firstName`, `displayName`)
3. **Email username** (fallback: part before @ symbol)
4. **"User"** (final fallback)

### 📝 **Current Limitations**

1. **Limited Application Data**: Only basic info is stored in job_applications
2. **No Resume/CV**: No document attachments are saved
3. **No Cover Letter**: No additional application text
4. **No Application-Specific Data**: No job-specific questions or answers

### 🚀 **Potential Enhancements**

To make applications more comprehensive, you could add:

```dart
// Enhanced application data
{
  'jobId': job['id'],
  'candidateEmail': user.email,
  'candidateName': _candidateName,
  'candidatePhone': candidatePhone,     // Add phone number
  'candidateLocation': candidateLocation, // Add location
  'resumeUrl': resumeUrl,               // Add resume attachment
  'coverLetter': coverLetter,           // Add cover letter text
  'expectedSalary': expectedSalary,     // Add salary expectation
  'availableFrom': availableFrom,       // Add availability date
  'applicationAnswers': answers,        // Add job-specific questions
  'appliedAt': FieldValue.serverTimestamp(),
  'status': 'pending',
}
```

### 🔧 **Technical Implementation**

**File**: `lib/simple_candidate_dashboard.dart`
**Method**: `_applyForJob(Map<String, dynamic> job)`
**Collection**: `job_applications`
**Document Structure**: Auto-generated ID with application data

**Retrieval**:
**File**: `lib/screens/job_applications_screen.dart`
**Method**: `_loadJobApplications()`
**Query**: `where('jobId', isEqualTo: widget.jobId)`