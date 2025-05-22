import React from 'react';
import { useNavigate } from 'react-router-dom';
import {
  Box,
  Typography,
  Button,
  Paper,
} from '@mui/material';
import {
  SentimentDissatisfied as SentimentDissatisfiedIcon,
  Home as HomeIcon,
} from '@mui/icons-material';

const NotFound = () => {
  const navigate = useNavigate();
  
  return (
    <Box
      sx={{
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'center',
        justifyContent: 'center',
        height: '70vh',
      }}
    >
      <Paper
        elevation={3}
        sx={{
          p: 5,
          textAlign: 'center',
          maxWidth: '500px',
        }}
      >
        <SentimentDissatisfiedIcon sx={{ fontSize: 80, color: 'text.secondary', mb: 2 }} />
        
        <Typography variant="h4" component="h1" gutterBottom>
          404 - Seite nicht gefunden
        </Typography>
        
        <Typography variant="body1" color="text.secondary" paragraph>
          Die angeforderte Seite existiert nicht. Möglicherweise haben Sie einen falschen Link verwendet oder die Seite wurde verschoben.
        </Typography>
        
        <Button
          variant="contained"
          color="primary"
          startIcon={<HomeIcon />}
          onClick={() => navigate('/')}
          sx={{ mt: 2 }}
        >
          Zur Startseite
        </Button>
      </Paper>
    </Box>
  );
};

export default NotFound;
