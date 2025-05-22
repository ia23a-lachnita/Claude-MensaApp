import React, { useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { useNavigate } from 'react-router-dom';
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
import { register } from '../../store/auth/authActions';

const RegisterSchema = Yup.object().shape({
  vorname: Yup.string()
    .min(2, 'Vorname muss mindestens 2 Zeichen lang sein')
    .max(50, 'Vorname darf maximal 50 Zeichen lang sein')
    .required('Vorname ist erforderlich'),
  nachname: Yup.string()
    .min(2, 'Nachname muss mindestens 2 Zeichen lang sein')
    .max(50, 'Nachname darf maximal 50 Zeichen lang sein')
    .required('Nachname ist erforderlich'),
  email: Yup.string()
    .email('Ungültige E-Mail-Adresse')
    .required('E-Mail ist erforderlich'),
  password: Yup.string()
    .min(8, 'Passwort muss mindestens 8 Zeichen lang sein')
    .matches(
      /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/,
      'Passwort muss mindestens einen Grossbuchstaben, einen Kleinbuchstaben und eine Zahl enthalten'
    )
    .required('Passwort ist erforderlich'),
  confirmPassword: Yup.string()
    .oneOf([Yup.ref('password'), null], 'Passwörter müssen übereinstimmen')
    .required('Passwortbestätigung ist erforderlich'),
});

const RegisterForm = () => {
  const dispatch = useDispatch();
  const navigate = useNavigate();
  const { loading, error } = useSelector(state => state.auth);
  const [showPassword, setShowPassword] = useState(false);
  const [showConfirmPassword, setShowConfirmPassword] = useState(false);

  const handleSubmit = async (values, { resetForm }) => {
    const userData = {
      vorname: values.vorname,
      nachname: values.nachname,
      email: values.email,
      password: values.password,
    };

    const result = await dispatch(register(userData));
    if (result) {
      resetForm();
      navigate('/login');
    }
  };

  const handlePasswordVisibility = () => {
    setShowPassword(!showPassword);
  };

  const handleConfirmPasswordVisibility = () => {
    setShowConfirmPassword(!showConfirmPassword);
  };

  return (
    <Formik
      initialValues={{
        vorname: '',
        nachname: '',
        email: '',
        password: '',
        confirmPassword: '',
      }}
      validationSchema={RegisterSchema}
      onSubmit={handleSubmit}
    >
      {({ errors, touched }) => (
        <Form>
          <Grid container spacing={3}>
            <Grid item xs={12} sm={6}>
              <Field
                as={TextField}
                fullWidth
                id="vorname"
                name="vorname"
                label="Vorname"
                variant="outlined"
                error={touched.vorname && Boolean(errors.vorname)}
                helperText={touched.vorname && errors.vorname}
              />
            </Grid>
            <Grid item xs={12} sm={6}>
              <Field
                as={TextField}
                fullWidth
                id="nachname"
                name="nachname"
                label="Nachname"
                variant="outlined"
                error={touched.nachname && Boolean(errors.nachname)}
                helperText={touched.nachname && errors.nachname}
              />
            </Grid>
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
            <Grid item xs={12}>
              <Field
                as={TextField}
                fullWidth
                id="confirmPassword"
                name="confirmPassword"
                label="Passwort bestätigen"
                type={showConfirmPassword ? 'text' : 'password'}
                variant="outlined"
                error={touched.confirmPassword && Boolean(errors.confirmPassword)}
                helperText={touched.confirmPassword && errors.confirmPassword}
                InputProps={{
                  endAdornment: (
                    <InputAdornment position="end">
                      <IconButton
                        aria-label="toggle password visibility"
                        onClick={handleConfirmPasswordVisibility}
                        edge="end"
                      >
                        {showConfirmPassword ? <VisibilityOff /> : <Visibility />}
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
                {loading ? 'Registrierung...' : 'Registrieren'}
              </Button>
            </Grid>
            <Grid item xs={12} container justifyContent="center">
              <Grid item>
                <Link href="/login" variant="body2" color="primary">
                  Bereits ein Konto? Anmelden
                </Link>
              </Grid>
            </Grid>
          </Grid>
        </Form>
      )}
    </Formik>
  );
};

export default RegisterForm;
