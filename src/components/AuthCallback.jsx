import { useEffect, useState } from 'react';
import { useNavigate, useSearchParams } from 'react-router-dom';
import { useSetRecoilState } from 'recoil';
import { userInfoState } from '../utils/atom';
import toast, { Toaster } from 'react-hot-toast';
import api from '../utils/axios';
import { FaGraduationCap } from 'react-icons/fa';

const AuthCallback = () => {
  const [searchParams] = useSearchParams();
  const navigate = useNavigate();
  const setUserInfoState = useSetRecoilState(userInfoState);
  const [isProcessing, setIsProcessing] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const processGoogleCallback = async () => {
      try {
        // Get the code from the URL (this is sent by Google)
        const code = searchParams.get('code');
        
        if (!code) {
          setError('No authentication code received');
          setIsProcessing(false);
          return;
        }
        
        // Send the code to your backend
        const response = await api.get(`/api/auth/google/callback?code=${code}`);
        
        // Process the response
        const { token, user } = response.data;
        const tokenWithBearer = `Bearer ${token}`;
        
        // Store the authentication data
        localStorage.clear();
        localStorage.setItem('token', tokenWithBearer);
        localStorage.setItem('role', user.role);
        localStorage.setItem('userInfo', JSON.stringify(user));
        
        // Update app state
        setUserInfoState({
          access_token: tokenWithBearer,
          user,
        });
        
        // Show success message
        toast.success('Login successful!');
        
        // Redirect based on role
        setTimeout(() => {
          if (user.role === 'student') {
            navigate('/student-dashboard');
          } else if (user.role === 'course_rep') {
            navigate('/course-representative-dashboard');
          }
        }, 1000);
        
      } catch (err) {
        console.error('Error in Google callback processing:', err);
        
        // Get specific error message if available
        let errorMessage = 'Authentication failed. Please try again.';
        if (err.response?.data?.error === 'account_not_found') {
          errorMessage = 'Please sign up first before using Google sign-in';
        } else if (err.response?.data?.message) {
          errorMessage = err.response.data.message;
        } else if (err.response?.data?.error) {
          errorMessage = err.response.data.error;
        }
        
        setError(errorMessage);
        toast.error(errorMessage);
      } finally {
        setIsProcessing(false);
      }
    };
    
    processGoogleCallback();
  }, [searchParams, navigate, setUserInfoState]);

  const handleTryAgain = () => {
    navigate('/login');
  };

  return (
    <div className="flex flex-col min-h-screen bg-[#f8fafb]">
      {/* Header */}
      <header className="sticky top-0 z-50 flex items-center justify-between whitespace-nowrap border-b border-[#e8eef3] bg-[#f8fafb] px-4 sm:px-10 py-3">
        <div className="flex items-center gap-4 text-[#0e161b]">
          <FaGraduationCap className="h-6 w-6" />
          <h2 className="text-lg font-bold leading-tight tracking-tight">StudyMate</h2>
        </div>
      </header>
      
      {/* Main content */}
      <div className="flex-1 flex items-center justify-center px-4 py-10">
        <Toaster />
        <div className="max-w-md w-full bg-white rounded-xl shadow-md p-8">
          {isProcessing ? (
            <div className="text-center">
              <h2 className="text-xl font-semibold mb-4 text-[#0e161b]">Processing your login</h2>
              <div className="animate-spin rounded-full h-10 w-10 border-b-2 border-[#0e161b] mx-auto mb-4"></div>
              <p className="text-gray-600">Please wait while we complete your sign-in...</p>
            </div>
          ) : error ? (
            <div className="text-center">
              <svg xmlns="http://www.w3.org/2000/svg" className="h-12 w-12 text-red-500 mx-auto mb-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
              <h2 className="text-xl font-semibold mb-2 text-[#0e161b]">Authentication Error</h2>
              <p className="text-gray-600 mb-6">{error}</p>
              <button
                onClick={handleTryAgain}
                className="px-4 py-2 bg-black text-white rounded-xl font-medium hover:bg-gray-800 transition-colors"
              >
                Back to Login
              </button>
            </div>
          ) : (
            <div className="text-center">
              <svg xmlns="http://www.w3.org/2000/svg" className="h-12 w-12 text-green-500 mx-auto mb-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
              </svg>
              <h2 className="text-xl font-semibold mb-2 text-[#0e161b]">Login Successful!</h2>
              <p className="text-gray-600 mb-2">You will be redirected to your dashboard shortly...</p>
            </div>
          )}
        </div>
      </div>
    </div>
  );
};

export default AuthCallback; 