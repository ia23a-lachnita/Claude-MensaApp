import React, { useState, useEffect } from 'react';
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
  Box,
  Link,
  Stepper,
  Step,
  StepLabel,
  Alert,
} from '@mui/material';
import { setupMfa, enableMfa, disableMfa } from '../../store/auth/authActions';
import { toast } from 'react-toastify';

const MfaCodeSchema = Yup.object().shape({
  code: Yup.string()
      .matches(/^\d{6}$/, 'Code muss 6 Ziffern enthalten')
      .required('Code ist erforderlich'),
});

const MfaSetupForm = () => {
  const dispatch = useDispatch();
  const { user } = useSelector(state => state.auth);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const [qrCodeUrl, setQrCodeUrl] = useState('');
  const [secret, setSecret] = useState('');
  const [activeStep, setActiveStep] = useState(0);
  const [mfaEnabled, setMfaEnabled] = useState(user?.mfaEnabled || false);

  useEffect(() => {
    if (user) {
      setMfaEnabled(user.mfaEnabled);
    }
  }, [user]);

  const steps = mfaEnabled
      ? ['MFA deaktivieren']
      : ['QR-Code scannen', 'Code verifizieren'];

  const handleSetup = async () => {
    setLoading(true);
    setError(null);
    try {
      const response = await dispatch(setupMfa(user.email));
      setQrCodeUrl(response.qrCodeUrl);
      setSecret(response.secret);
      setActiveStep(1);
    } catch (error) {
      setError('Fehler beim Einrichten der Zwei-Faktor-Authentifizierung');
    } finally {
      setLoading(false);
    }
  };

  const handleEnableMfa = async (values) => {
    setLoading(true);
    setError(null);
    try {
      const result = await dispatch(enableMfa(user.email, values.code));
      if (result) {
        setMfaEnabled(true);
        setActiveStep(0);
      } else {
        setError('Ungültiger Code');
      }
    } catch (error) {
      // Handle account lock specifically for MFA enable
      if (error.response?.status === 423) { // HTTP 423 Locked
        setError('Ihr Account wurde nach 3 fehlgeschlagenen MFA-Versuchen für 10 Minuten gesperrt. Sie erhalten eine E-Mail-Benachrichtigung.');
        toast.error('Account wurde gesperrt. Bitte versuchen Sie es in 10 Minuten erneut.', {
          autoClose: 8000
        });
      } else {
        setError('Fehler beim Aktivieren der Zwei-Faktor-Authentifizierung');
      }
    } finally {
      setLoading(false);
    }
  };

  const handleDisableMfa = async (values) => {
    setLoading(true);
    setError(null);
    try {
      const result = await dispatch(disableMfa(user.email, values.code));
      if (result) {
        setMfaEnabled(false);
      } else {
        setError('Ungültiger Code');
      }
    } catch (error) {
      // Handle account lock specifically for MFA disable
      if (error.response?.status === 423) { // HTTP 423 Locked
        setError('Ihr Account wurde nach 3 fehlgeschlagenen MFA-Versuchen für 10 Minuten gesperrt. Sie erhalten eine E-Mail-Benachrichtigung.');
        toast.error('Account wurde gesperrt. Bitte versuchen Sie es in 10 Minuten erneut.', {
          autoClose: 8000
        });
      } else {
        setError('Fehler beim Deaktivieren der Zwei-Faktor-Authentifizierung');
      }
    } finally {
      setLoading(false);
    }
  };

  const renderStepContent = (step) => {
    if (mfaEnabled) {
      return (
          <Formik
              initialValues={{ code: '' }}
              validationSchema={MfaCodeSchema}
              onSubmit={handleDisableMfa}
          >
            {({ errors, touched }) => (
                <Form>
                  <Typography variant="body1" paragraph>
                    Um die Zwei-Faktor-Authentifizierung zu deaktivieren, geben Sie bitte den aktuellen Code aus Ihrer Authenticator-App ein.
                  </Typography>

                  {/* Security warning for disable */}
                  <Alert severity="warning" sx={{ mb: 2 }}>
                    <Typography variant="body2">
                      <strong>Sicherheitshinweis:</strong> Nach 3 fehlgeschlagenen Versuchen wird Ihr Account für 10 Minuten gesperrt.
                    </Typography>
                  </Alert>

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
                      />
                    </Grid>
                    {error && (
                        <Grid item xs={12}>
                          <Alert severity="error">
                            <Typography>{error}</Typography>
                          </Alert>
                        </Grid>
                    )}
                    <Grid item xs={12}>
                      <Button
                          type="submit"
                          fullWidth
                          variant="contained"
                          color="secondary"
                          disabled={loading}
                          sx={{ py: 1.5 }}
                          startIcon={loading && <CircularProgress size={20} color="inherit" />}
                      >
                        {loading ? 'Wird deaktiviert...' : 'MFA deaktivieren'}
                      </Button>
                    </Grid>
                  </Grid>
                </Form>
            )}
          </Formik>
      );
    }

    switch (step) {
      case 0:
        return (
            <Box sx={{ textAlign: 'center' }}>
              <Typography variant="body1" paragraph>
                Die Zwei-Faktor-Authentifizierung erhöht die Sicherheit Ihres Kontos. Sobald aktiviert, müssen Sie bei jeder Anmeldung einen Code aus einer Authenticator-App eingeben.
              </Typography>
              <Button
                  variant="contained"
                  color="primary"
                  onClick={handleSetup}
                  disabled={loading}
                  sx={{ mt: 2 }}
                  startIcon={loading && <CircularProgress size={20} color="inherit" />}
              >
                {loading ? 'Wird eingerichtet...' : 'MFA einrichten'}
              </Button>
            </Box>
        );
      case 1:
        return (
            <Box sx={{ textAlign: 'center' }}>
              <Typography variant="body1" paragraph>
                Scannen Sie den QR-Code mit Ihrer Authenticator-App (z.B. Google Authenticator, Authy, Microsoft Authenticator) oder geben Sie den Code manuell ein.
              </Typography>
              <Box sx={{ my: 3 }}>
                {qrCodeUrl && (
                    <img
                        src={qrCodeUrl}
                        alt="QR-Code für Zwei-Faktor-Authentifizierung"
                        style={{ maxWidth: '100%', height: 'auto' }}
                    />
                )}
              </Box>
              <Typography variant="subtitle2" paragraph>
                Manueller Einrichtungscode:
              </Typography>
              <Typography
                  variant="body2"
                  sx={{
                    backgroundColor: 'grey.100',
                    padding: 2,
                    borderRadius: 1,
                    fontFamily: 'monospace',
                    wordBreak: 'break-all',
                  }}
              >
                {secret}
              </Typography>
              <Button
                  variant="contained"
                  color="primary"
                  onClick={() => setActiveStep(2)}
                  sx={{ mt: 3 }}
              >
                Weiter
              </Button>
            </Box>
        );
      case 2:
        return (
            <Formik
                initialValues={{ code: '' }}
                validationSchema={MfaCodeSchema}
                onSubmit={handleEnableMfa}
            >
              {({ errors, touched }) => (
                  <Form>
                    <Typography variant="body1" paragraph>
                      Geben Sie den 6-stelligen Code aus Ihrer Authenticator-App ein, um die Einrichtung abzuschliessen.
                    </Typography>

                    {/* Security warning for enable */}
                    <Alert severity="info" sx={{ mb: 2 }}>
                      <Typography variant="body2">
                        <strong>Sicherheitshinweis:</strong> Nach 3 fehlgeschlagenen Versuchen wird Ihr Account für 10 Minuten gesperrt.
                      </Typography>
                    </Alert>

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
                        />
                      </Grid>
                      {error && (
                          <Grid item xs={12}>
                            <Alert severity="error">
                              <Typography>{error}</Typography>
                            </Alert>
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
                          {loading ? 'Wird aktiviert...' : 'MFA aktivieren'}
                        </Button>
                      </Grid>
                    </Grid>
                  </Form>
              )}
            </Formik>
        );
      default:
        return null;
    }
  };

  return (
      <Paper elevation={3} sx={{ p: 4 }}>
        <Typography variant="h5" gutterBottom align="center">
          Zwei-Faktor-Authentifizierung
        </Typography>

        <Box sx={{ width: '100%', mb: 4 }}>
          <Stepper activeStep={activeStep} alternativeLabel>
            {steps.map((label) => (
                <Step key={label}>
                  <StepLabel>{label}</StepLabel>
                </Step>
            ))}
          </Stepper>
        </Box>

        {renderStepContent(activeStep)}
      </Paper>
  );
};

export default MfaSetupForm;
