import { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useSetRecoilState } from 'recoil';
import { userInfoState } from '../utils/atom';
import toast from 'react-hot-toast';
import axios from 'axios';

const GoogleAuthCallback = () => {
  const navigate = useNavigate();
  const setUserInfoState = useSetRecoilState(userInfoState);
  const [isProcessing, setIsProcessing] = useState(true);

  useEffect(() => {
    const processGoogleAuth = async () => {
      try {
        // Get the code from URL
        const urlParams = new URLSearchParams(window.location.search);
        const code = urlParams.get('code');

        if (!code) {
          toast.error('No authentication code received');
          navigate('/login');
          return;
        }

        // Call backend to process the code
        const response = await axios.get(`/api/auth/google/callback?code=${code}`);
        const { token, user } = response.data;

        // Store the authentication data
        const tokenWithBearer = `Bearer ${token}`;
        localStorage.setItem('token', tokenWithBearer);
        localStorage.setItem('role', user.role);
        localStorage.setItem('userInfo', JSON.stringify(user));

        // Update app state
        setUserInfoState({
          access_token: tokenWithBearer,
          user: user,
        });

        // Show success message
        toast.success('Login successful!');

        // Redirect based on role
        if (user.role === 'student') {
          navigate('/student-dashboard');
        } else if (user.role === 'course_rep') {
          navigate('/course-representative-dashboard');
        } else {
          navigate('/login');
        }
      } catch (error) {
        console.error('Google auth error:', error);
        
        // Handle specific error cases
        if (error.response) {
          const { error: errorType, message } = error.response.data;
          
          if (errorType === 'account_not_found') {
            toast.error('Please sign up first before using Google sign-in');
          } else if (errorType === 'invalid_grant') {
            toast.error('Your authentication session has expired. Please try again.');
          } else {
            toast.error(message || 'Authentication failed. Please try again.');
          }
        } else {
          toast.error('An error occurred during authentication');
        }
        
        navigate('/login');
      } finally {
        setIsProcessing(false);
      }
    };

    processGoogleAuth();
  }, [navigate, setUserInfoState]);

  if (isProcessing) {
    return (
      <div className="flex items-center justify-center min-h-screen bg-gray-100">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-gray-900 mx-auto"></div>
          <p className="mt-4 text-gray-600">Processing your login...</p>
        </div>
      </div>
    );
  }

  return null;
};

export default GoogleAuthCallback; 