import React from 'react';
import { Box, Typography, Button } from '@mui/material';

const EmptyState = ({
  title,
  message,
  actionText,
  actionIcon,
  onAction,
  icon: Icon,
}) => {
  return (
    <Box
      sx={{
        textAlign: 'center',
        py: 6,
        px: 2,
        my: 4,
        borderRadius: 2,
        bgcolor: 'background.paper',
        boxShadow: 1,
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'center',
      }}
    >
      {Icon && <Icon sx={{ fontSize: 80, color: 'text.secondary', mb: 2 }} />}
      <Typography variant="h5" component="h2" gutterBottom>
        {title}
      </Typography>
      <Typography variant="body1" color="text.secondary" paragraph>
        {message}
      </Typography>
      {actionText && onAction && (
        <Button
          variant="contained"
          color="primary"
          onClick={onAction}
          startIcon={actionIcon}
          sx={{ mt: 2 }}
        >
          {actionText}
        </Button>
      )}
    </Box>
  );
};

export default EmptyState;
