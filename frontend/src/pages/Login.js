import React, { useEffect } from 'react';
import { useSelector } from 'react-redux';
import { useNavigate, useLocation } from 'react-router-dom';
import {
  Paper,
  Typography,
  Box,
  Container,
  Grid,
} from '@mui/material';
import LoginForm from '../components/auth/LoginForm';
import PageTitle from '../components/common/PageTitle';

const Login = () => {
  const navigate = useNavigate();
  const location = useLocation();
  const isLoggedIn = useSelector(state => state.auth.isLoggedIn);
  
  const from = location.state?.from || '/';
  
  useEffect(() => {
    if (isLoggedIn) {
      navigate(from, { replace: true });
    }
  }, [isLoggedIn, navigate, from]);
  
  return (
    <Container maxWidth="sm">
      <Grid container justifyContent="center">
        <Grid item xs={12}>
          <Paper elevation={3} sx={{ p: 4, mb: 4 }}>
            <PageTitle 
              title="Anmelden" 
              subtitle="Melden Sie sich an, um fortzufahren"
            />
            
            <LoginForm />
          </Paper>
        </Grid>
      </Grid>
    </Container>
  );
};

export default Login;
