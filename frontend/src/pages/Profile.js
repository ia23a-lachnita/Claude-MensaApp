import React, { useState, useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import {
  TextField,  // Keep TextField only here
  Box,
  Grid,
  Typography,
  Button,
  Paper,
  Tabs,
  Tab,
  Divider,
} from '@mui/material';
import {
  Person as PersonIcon,
  VpnKey as VpnKeyIcon,
  Security as SecurityIcon,
} from '@mui/icons-material';
import { toast } from 'react-toastify';

// Rest of your imports
import PageTitle from '../components/common/PageTitle';
import { userService } from '../services/api';
import { updateProfile, updatePassword } from '../store/auth/authActions';
import { Formik, Form, Field } from 'formik';
import * as Yup from 'yup';
import MfaSetupForm from '../components/auth/MfaSetupForm';

const ProfileSchema = Yup.object().shape({
  vorname: Yup.string()
    .required('Vorname ist erforderlich')
    .min(2, 'Vorname muss mindestens 2 Zeichen lang sein')
    .max(50, 'Vorname darf maximal 50 Zeichen lang sein'),
  nachname: Yup.string()
    .required('Nachname ist erforderlich')
    .min(2, 'Nachname muss mindestens 2 Zeichen lang sein')
    .max(50, 'Nachname darf maximal 50 Zeichen lang sein'),
  email: Yup.string()
    .email('Ungültige E-Mail-Adresse')
    .required('E-Mail ist erforderlich'),
});

const PasswordSchema = Yup.object().shape({
  altesPassword: Yup.string()
    .required('Aktuelles Passwort ist erforderlich'),
  neuesPassword: Yup.string()
    .required('Neues Passwort ist erforderlich')
    .min(8, 'Passwort muss mindestens 8 Zeichen lang sein')
    .matches(
      /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/,
      'Passwort muss mindestens einen Grossbuchstaben, einen Kleinbuchstaben und eine Zahl enthalten'
    ),
  neuesPasswordBestaetigung: Yup.string()
    .oneOf([Yup.ref('neuesPassword'), null], 'Passwörter müssen übereinstimmen')
    .required('Passwortbestätigung ist erforderlich'),
});

const Profile = () => {
  const dispatch = useDispatch();
  const user = useSelector(state => state.auth.user);
  const [tabValue, setTabValue] = useState(0);
  const [loading, setLoading] = useState(false);
  
  const handleTabChange = (event, newValue) => {
    setTabValue(newValue);
  };
  
  const handleProfileUpdate = async (values) => {
    setLoading(true);
    try {
      await dispatch(updateProfile(values));
      setLoading(false);
    } catch (error) {
      setLoading(false);
    }
  };
  
  const handlePasswordUpdate = async (values, { resetForm }) => {
    setLoading(true);
    try {
      const success = await dispatch(updatePassword({
        altesPassword: values.altesPassword,
        neuesPassword: values.neuesPassword,
      }));
      
      if (success) {
        resetForm();
      }
      setLoading(false);
    } catch (error) {
      setLoading(false);
    }
  };
  
  const renderProfileTab = () => {
    return (
      <Box sx={{ mt: 3 }}>
        <Formik
          initialValues={{
            vorname: user?.vorname || '',
            nachname: user?.nachname || '',
            email: user?.email || '',
          }}
          validationSchema={ProfileSchema}
          onSubmit={handleProfileUpdate}
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
                  <Button
                    type="submit"
                    variant="contained"
                    color="primary"
                    disabled={loading}
                    sx={{ mt: 1 }}
                  >
                    {loading ? 'Wird gespeichert...' : 'Profil aktualisieren'}
                  </Button>
                </Grid>
              </Grid>
            </Form>
          )}
        </Formik>
      </Box>
    );
  };
  
  const renderPasswordTab = () => {
    return (
      <Box sx={{ mt: 3 }}>
        <Formik
          initialValues={{
            altesPassword: '',
            neuesPassword: '',
            neuesPasswordBestaetigung: '',
          }}
          validationSchema={PasswordSchema}
          onSubmit={handlePasswordUpdate}
        >
          {({ errors, touched }) => (
            <Form>
              <Grid container spacing={3}>
                <Grid item xs={12}>
                  <Field
                    as={TextField}
                    fullWidth
                    id="altesPassword"
                    name="altesPassword"
                    label="Aktuelles Passwort"
                    type="password"
                    variant="outlined"
                    error={touched.altesPassword && Boolean(errors.altesPassword)}
                    helperText={touched.altesPassword && errors.altesPassword}
                  />
                </Grid>
                
                <Grid item xs={12}>
                  <Field
                    as={TextField}
                    fullWidth
                    id="neuesPassword"
                    name="neuesPassword"
                    label="Neues Passwort"
                    type="password"
                    variant="outlined"
                    error={touched.neuesPassword && Boolean(errors.neuesPassword)}
                    helperText={touched.neuesPassword && errors.neuesPassword}
                  />
                </Grid>
                
                <Grid item xs={12}>
                  <Field
                    as={TextField}
                    fullWidth
                    id="neuesPasswordBestaetigung"
                    name="neuesPasswordBestaetigung"
                    label="Passwort bestätigen"
                    type="password"
                    variant="outlined"
                    error={touched.neuesPasswordBestaetigung && Boolean(errors.neuesPasswordBestaetigung)}
                    helperText={touched.neuesPasswordBestaetigung && errors.neuesPasswordBestaetigung}
                  />
                </Grid>
                
                <Grid item xs={12}>
                  <Button
                    type="submit"
                    variant="contained"
                    color="primary"
                    disabled={loading}
                    sx={{ mt: 1 }}
                  >
                    {loading ? 'Wird aktualisiert...' : 'Passwort ändern'}
                  </Button>
                </Grid>
              </Grid>
            </Form>
          )}
        </Formik>
      </Box>
    );
  };
  
  return (
    <Box>
      <PageTitle title="Mein Profil" subtitle="Verwalten Sie Ihre persönlichen Informationen" />
      
      <Paper elevation={3} sx={{ p: 3 }}>
        <Tabs
          value={tabValue}
          onChange={handleTabChange}
          variant="fullWidth"
          aria-label="Profil Tabs"
        >
          <Tab label="Persönliche Daten" icon={<PersonIcon />} />
          <Tab label="Passwort ändern" icon={<VpnKeyIcon />} />
          <Tab label="Zwei-Faktor-Authentifizierung" icon={<SecurityIcon />} />
        </Tabs>
        
        <Divider sx={{ mb: 3 }} />
        
        {tabValue === 0 && renderProfileTab()}
        {tabValue === 1 && renderPasswordTab()}
        {tabValue === 2 && <MfaSetupForm />}
      </Paper>
    </Box>
  );
};

export default Profile;
