import React from 'react';
import { Box, Alert, Typography, Button } from '@mui/material';
import { Refresh as RefreshIcon } from '@mui/icons-material';

const ErrorMessage = ({ message, onRetry }) => {
  return (
    <Box sx={{ my: 4 }}>
      <Alert severity="error" sx={{ mb: 2 }}>
        <Typography variant="body1">
          {message || 'Ein Fehler ist aufgetreten.'}
        </Typography>
      </Alert>
      {onRetry && (
        <Button
          variant="outlined"
          color="primary"
          startIcon={<RefreshIcon />}
          onClick={onRetry}
        >
          Erneut versuchen
        </Button>
      )}
    </Box>
  );
};

export default ErrorMessage;
