import React, { useEffect, useState } from 'react';
import axios from 'axios';
import AlertModal from './AlertModal';
import AuthFailedModal from './AuthFailedModal';
import AccountModal from './AccountModal';

const ReAuth = ({ onReAuthComplete }) => {
  const [alertMessage, setAlertMessage] = useState("");
  const [showAlert, setShowAlert] = useState(false);
  const [showAuthFailedModal, setShowAuthFailedModal] = useState(false);
  const [showAccountModal, setShowAccountModal] = useState(false);

  useEffect(() => {
    const authData = localStorage.getItem('auth') || sessionStorage.getItem('auth');
    if (authData) {
      const { token } = JSON.parse(authData);
      axios.post('http://localhost:5000/api/validateToken', { token })
        .then(response => {
          if (response.data.success) {
          } else {
            localStorage.removeItem('auth');
            sessionStorage.removeItem('auth');
            setAlertMessage("Login Failed! Please log in again.");
            setShowAuthFailedModal(true);
            setShowAlert(true);
          }
        })
        .catch(() => {
          localStorage.removeItem('auth');
          sessionStorage.removeItem('auth');
          setAlertMessage("Login Failed! Please log in again.");
          setShowAuthFailedModal(true);
        })
        .finally(() => {
          onReAuthComplete();
        });
    }
  }, [onReAuthComplete]);

  const closeAlert = () => {
    setShowAlert(false);
  };

  const closeAuthFailedModal = () => {
    setShowAuthFailedModal(false);
    window.location.reload();
  };

  const handleLoginAgain = () => {
    setShowAuthFailedModal(false);
    setShowAccountModal(true);
  };

  const handleAccountModalClose = () => {
    setShowAccountModal(false);
    window.location.reload();
  };

  return (
    <>
      {showAlert && <AlertModal message={alertMessage} onClose={closeAlert} />}
      {showAuthFailedModal && (
        <AuthFailedModal 
          message={alertMessage} 
          onClose={closeAuthFailedModal} 
          onLogin={handleLoginAgain} 
        />
      )}
      {showAccountModal && <AccountModal onClose={handleAccountModalClose} />}
    </>
  );
};

export default ReAuth;