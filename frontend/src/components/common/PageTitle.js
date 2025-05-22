import React from 'react';
import { Typography, Box, Divider } from '@mui/material';

const PageTitle = ({ title, subtitle, children }) => {
  return (
    <Box sx={{ mb: 4 }}>
      <Typography variant="h4" component="h1" gutterBottom>
        {title}
      </Typography>
      {subtitle && (
        <Typography variant="subtitle1" color="text.secondary" paragraph>
          {subtitle}
        </Typography>
      )}
      {children}
      <Divider sx={{ mt: 2 }} />
    </Box>
  );
};

export default PageTitle;
