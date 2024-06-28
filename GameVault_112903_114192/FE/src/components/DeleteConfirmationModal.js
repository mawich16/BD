import React from 'react';

const DeleteConfirmationModal = ({ isVisible, review, onConfirm, onCancel }) => {
  if (!isVisible || !review) return null;

  return (
    <div className="fixed inset-0 flex items-center justify-center bg-black bg-opacity-50 z-50">
      <div className="bg-white p-6 rounded-lg shadow-lg w-80">
        <h2 className="text-2xl font-bold mb-4">Confirm Deletion</h2>
        <p className="mb-4">Are you sure you want to delete the following review?</p>
        <p className="mb-2"><strong>Rating:</strong> {review.rating}</p>
        <p className="mb-4"><strong>Comment:</strong> {review.review}</p>
        <div className="flex justify-end">
          <button
            className="bg-gray-300 text-gray-700 py-2 px-4 rounded-md mr-2 hover:bg-gray-400"
            onClick={onCancel}
          >
            Cancel
          </button>
          <button
            className="bg-red-600 text-white py-2 px-4 rounded-md hover:bg-red-700"
            onClick={onConfirm}
          >
            Delete
          </button>
        </div>
      </div>
    </div>
  );
};

export default DeleteConfirmationModal;