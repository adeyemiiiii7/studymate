import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import AuthCallback from './components/AuthCallback';

function App() {
  return (
    <Router>
      <Routes>
        {/* ... other routes ... */}
        <Route path="/auth/callback" element={<AuthCallback />} />
      </Routes>
    </Router>
  );
}

export default App; 