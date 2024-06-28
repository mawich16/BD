import React, { useEffect } from 'react';

const AlertModal = ({ message, onClose }) => {
    useEffect(() => {
        const timer = setTimeout(() => {
            onClose();
        }, 3000);

        return () => clearTimeout(timer);
    }, [onClose]);

    return (
        <div className="fixed top-0 left-0 right-0 bg-red-600 text-white text-center py-2 z-50">
            {message}
        </div>
    );
};

export default AlertModal;
