const multer = require('multer');
const { CloudinaryStorage } = require('multer-storage-cloudinary');
const cloudinary = require('../config/cloudinary');

// Create a CloudinaryStorage instance with better handling for document types
const storage = new CloudinaryStorage({
  cloudinary: cloudinary,
  params: (req, file) => {
    console.log('Processing file:', file.originalname, 'MIME type:', file.mimetype);
    
    // Create a safer public_id by removing all special characters
    const timestamp = Date.now();
    const safeName = file.originalname
      .replace(/\s+/g, '_')
      .replace(/[^a-zA-Z0-9_.-]/g, '')
      .replace(/\.+$/, '');
    
    if (file.mimetype.startsWith('image/')) {
      return {
        folder: 'images',
        resource_type: 'image',
        public_id: `${timestamp}-${safeName}`
      };
    } else {
      return {
        folder: 'documents',
        resource_type: 'raw',
        public_id: `${timestamp}-${safeName}`
      };
    }
  }
});
const fileFilter = (req, file, cb) => {
  console.log('Filtering file:', file.originalname, 'MIME type:', file.mimetype);
  
  const allowedMimeTypes = [
    'application/pdf',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 
    'application/msword', 
    'application/vnd.openxmlformats-officedocument.presentationml.presentation', 
    'application/vnd.ms-powerpoint', 
    'image/jpeg',
    'image/png',
    'image/gif'
  ];
  
  if (allowedMimeTypes.includes(file.mimetype)) {
    cb(null, true);
  } else {
    console.error('Rejected file:', file.originalname, 'MIME type:', file.mimetype);
    cb(new Error(`Unsupported file type: ${file.mimetype}. Only PDF, DOCX, DOC, PPTX, PPT, JPG, PNG, and GIF are allowed.`), false);
  }
};
// Set up multer with Cloudinary storage and file filter
const upload = multer({
  storage: storage,
  fileFilter: fileFilter,
  limits: {
    fileSize: 20 * 1024 * 1024, // 20MB file size limit
  }
});
// Add error handling middleware for multer errors
const handleMulterErrors = (err, req, res, next) => {
  if (err) {
    console.error('Upload error:', err);
    return res.status(400).json({
      error: `File upload error: ${err.message}`
    });
  }
  next();
};
module.exports = { upload, handleMulterErrors };