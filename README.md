# Flutter Supabase Auth

A simple and clean Flutter authentication application built using Flutter, Supabase, GetX, and SharedPreferences.

---

## Overview

This app allows users to sign in, view their profile, and update personal information including a profile image.  
It provides a modern and user-friendly interface with secure authentication and local data persistence.

---

## Features

- User authentication with:
  - Email and Password
  - Google Sign-In
  - Apple Sign-In

- View profile information:
  - Profile image
  - Full name
  - Username
  - Email
  - Phone number
  - Role
  - Bio
  - Address

- Edit and update profile details
- Upload profile image to Supabase Storage
- Logout securely

---

## Authentication Flow

The application follows a simple authentication flow:

- Splash Screen
- Check local storage and Supabase session
- Redirect to:
  - Login Screen if not authenticated
  - Profile Screen if already logged in

---

## Data Storage

The application uses two storage methods:

### Supabase Database

Stores user profile information:

- Full name
- Username
- Email
- Phone
- Role
- Bio
- Address
- Profile image path

### SharedPreferences

Stores local data such as:

- User ID
- Theme mode
- Cached profile data

---

## Supabase Storage

Profile images are uploaded to a storage bucket named:

- `images`

---

## UI Design

- Clean and modern user interface
- Responsive design for different screen sizes
- Light and Dark theme support
- Smooth navigation using GetX

---

## Screens Included

- Splash Screen
- Login Screen
- Profile Screen
- Edit Profile Screen

---

## Tech Stack

- Flutter – Mobile application framework
- Supabase – Authentication, Database, and Storage
- GetX – State management and navigation
- SharedPreferences – Local storage
- Image Picker – Select images from gallery
- Cached Network Image – Display profile images

---

## Environment Variables

Create a `.env` file in the root directory:

```env
URL=https://your-project.supabase.co
ANON_KEY=your-anon-key
```
