import React from "react";

const SuccessModal = ({ onClose, message }) => {

    const handleOverlayClick = (event) => {
        if (event.target === event.currentTarget) {
            onClose();
        }
    };

    return (
        <div className="fixed inset-0 flex items-center justify-center bg-black bg-opacity-50 z-50" onClick={handleOverlayClick}>
            <div className="relative bg-white p-6 rounded-lg shadow-lg w-80">
                <button className="absolute top-2 right-2 text-2xl" onClick={onClose}>&times;</button>
                <h2 className="text-2xl font-bold mb-4 text-center">Success</h2>
                <p className="mb-4">{message}</p>
                <button
                    className="w-full bg-red-600 text-white py-2 rounded-md hover:bg-red-700"
                    onClick={onClose}
                >
                    OK
                </button>
            </div>
        </div>
    );
};

export default SuccessModal;