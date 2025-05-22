import React, { useEffect } from 'react';
import { useSelector } from 'react-redux';
import { useNavigate } from 'react-router-dom';
import {
  Paper,
  Typography,
  Box,
  Container,
  Grid,
} from '@mui/material';
import RegisterForm from '../components/auth/RegisterForm';
import PageTitle from '../components/common/PageTitle';

const Register = () => {
  const navigate = useNavigate();
  const isLoggedIn = useSelector(state => state.auth.isLoggedIn);
  
  useEffect(() => {
    if (isLoggedIn) {
      navigate('/');
    }
  }, [isLoggedIn, navigate]);
  
  return (
    <Container maxWidth="md">
      <Grid container justifyContent="center">
        <Grid item xs={12}>
          <Paper elevation={3} sx={{ p: 4, mb: 4 }}>
            <PageTitle 
              title="Registrieren" 
              subtitle="Erstellen Sie ein neues Konto"
            />
            
            <RegisterForm />
          </Paper>
        </Grid>
      </Grid>
    </Container>
  );
};

export default Register;
