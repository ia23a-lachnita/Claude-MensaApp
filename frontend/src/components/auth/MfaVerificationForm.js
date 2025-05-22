import React from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Formik, Form, Field } from 'formik';
import * as Yup from 'yup';
import {
  TextField,
  Button,
  Grid,
  Typography,
  CircularProgress,
  Paper,
} from '@mui/material';
import { verifyMfa } from '../../store/auth/authActions';

const MfaVerificationSchema = Yup.object().shape({
  code: Yup.string()
    .matches(/^\d{6}$/, 'Code muss 6 Ziffern enthalten')
    .required('Code ist erforderlich'),
});

const MfaVerificationForm = ({ email, password, onSuccess }) => {
  const dispatch = useDispatch();
  const { loading, error } = useSelector(state => state.auth);

  const handleSubmit = async (values) => {
    const result = await dispatch(verifyMfa(email, password, values.code));
    if (result?.type === 'auth/loginSuccess' && onSuccess) {
      onSuccess();
    }
  };

  return (
    <Paper elevation={3} sx={{ p: 4 }}>
      <Typography variant="h5" gutterBottom align="center">
        Zwei-Faktor-Authentifizierung
      </Typography>
      <Typography variant="body1" paragraph>
        Bitte geben Sie den 6-stelligen Code aus Ihrer Authenticator-App ein.
      </Typography>
      
      <Formik
        initialValues={{
          code: '',
        }}
        validationSchema={MfaVerificationSchema}
        onSubmit={handleSubmit}
      >
        {({ errors, touched }) => (
          <Form>
            <Grid container spacing={3}>
              <Grid item xs={12}>
                <Field
                  as={TextField}
                  fullWidth
                  id="code"
                  name="code"
                  label="Authentifizierungscode"
                  variant="outlined"
                  error={touched.code && Boolean(errors.code)}
                  helperText={touched.code && errors.code}
                  autoComplete="off"
                  inputProps={{ maxLength: 6 }}
                  placeholder="6-stelligen Code eingeben"
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
                  {loading ? 'Überprüfung...' : 'Verifizieren'}
                </Button>
              </Grid>
            </Grid>
          </Form>
        )}
      </Formik>
    </Paper>
  );
};

export default MfaVerificationForm;
