import React, { useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { useNavigate, useLocation } from 'react-router-dom';
import { Formik, Form, Field } from 'formik';
import * as Yup from 'yup';
import {
  TextField,
  Button,
  Grid,
  Link,
  Typography,
  InputAdornment,
  IconButton,
  CircularProgress,
} from '@mui/material';
import { Visibility, VisibilityOff } from '@mui/icons-material';
import { login } from '../../store/auth/authActions';
import MfaVerificationForm from './MfaVerificationForm';

const LoginSchema = Yup.object().shape({
  email: Yup.string()
    .email('Ungültige E-Mail-Adresse')
    .required('E-Mail ist erforderlich'),
  password: Yup.string()
    .min(8, 'Passwort muss mindestens 8 Zeichen lang sein')
    .required('Passwort ist erforderlich'),
});

const LoginForm = () => {
  const dispatch = useDispatch();
  const navigate = useNavigate();
  const location = useLocation();
  const { loading, error, mfaRequired, mfaEmail, mfaPassword } = useSelector(state => state.auth);
  const [showPassword, setShowPassword] = useState(false);

  const from = location.state?.from || '/';

  const handleSubmit = (values) => {
    dispatch(login(values.email, values.password));
  };

  const handleMfaSuccess = () => {
    navigate(from, { replace: true });
  };

  const handlePasswordVisibility = () => {
    setShowPassword(!showPassword);
  };

  if (mfaRequired) {
    return <MfaVerificationForm 
      email={mfaEmail} 
      password={mfaPassword} 
      onSuccess={handleMfaSuccess} 
    />;
  }

  return (
    <Formik
      initialValues={{
        email: '',
        password: '',
      }}
      validationSchema={LoginSchema}
      onSubmit={handleSubmit}
    >
      {({ errors, touched }) => (
        <Form>
          <Grid container spacing={3}>
            <Grid item xs={12}>
              <Field
                as={TextField}
                fullWidth
                id="email"
                name="email"
                label="E-Mail"
                variant="outlined"
                error={touched.email && Boolean(errors.email)}
                helperText={touched.email && errors.email}
              />
            </Grid>
            <Grid item xs={12}>
              <Field
                as={TextField}
                fullWidth
                id="password"
                name="password"
                label="Passwort"
                type={showPassword ? 'text' : 'password'}
                variant="outlined"
                error={touched.password && Boolean(errors.password)}
                helperText={touched.password && errors.password}
                InputProps={{
                  endAdornment: (
                    <InputAdornment position="end">
                      <IconButton
                        aria-label="toggle password visibility"
                        onClick={handlePasswordVisibility}
                        edge="end"
                      >
                        {showPassword ? <VisibilityOff /> : <Visibility />}
                      </IconButton>
                    </InputAdornment>
                  ),
                }}
              />
            </Grid>
            {error && (
              <Grid item xs={12}>
                <Typography color="error">{error}</Typography>
              </Grid>
            )}
            <Grid item xs={12}>
              <Button
                type="submit"
                fullWidth
                variant="contained"
                color="primary"
                disabled={loading}
                sx={{ py: 1.5 }}
                startIcon={loading && <CircularProgress size={20} color="inherit" />}
              >
                {loading ? 'Anmeldung...' : 'Anmelden'}
              </Button>
            </Grid>
            <Grid item xs={12} container justifyContent="space-between">
              <Grid item>
                <Link href="#" variant="body2" color="primary">
                  Passwort vergessen?
                </Link>
              </Grid>
              <Grid item>
                <Link href="/register" variant="body2" color="primary">
                  Kein Konto? Registrieren
                </Link>
              </Grid>
            </Grid>
          </Grid>
        </Form>
      )}
    </Formik>
  );
};

export default LoginForm;
