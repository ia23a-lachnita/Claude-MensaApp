import React, { useState } from 'react';
import { Formik, Form, Field } from 'formik';
import * as Yup from 'yup';
import {
  TextField,
  Button,
  Grid,
  Typography,
  Paper,
  Box,
  FormControl,
  InputLabel,
  Select,
  MenuItem,
  FormHelperText,
  Divider,
  CircularProgress,
} from '@mui/material';
import { CreditCard, AccountBalance, Receipt } from '@mui/icons-material';

const PaymentSchema = Yup.object().shape({
  zahlungsMethode: Yup.string().required('Bitte wählen Sie eine Zahlungsmethode'),
  kartenNummer: Yup.string().when('zahlungsMethode', {
    is: 'KREDITKARTE',
    then: () => Yup.string()
      .required('Kartennummer ist erforderlich')
      .matches(/^\d{16}$/, 'Kartennummer muss 16 Ziffern haben'),
  }),
  kartenName: Yup.string().when('zahlungsMethode', {
    is: 'KREDITKARTE',
    then: () => Yup.string().required('Name ist erforderlich'),
  }),
  kartenCVV: Yup.string().when('zahlungsMethode', {
    is: 'KREDITKARTE',
    then: () => Yup.string()
      .required('CVV ist erforderlich')
      .matches(/^\d{3}$/, 'CVV muss 3 Ziffern haben'),
  }),
  kartenAblaufMonat: Yup.string().when('zahlungsMethode', {
    is: 'KREDITKARTE',
    then: () => Yup.string()
      .required('Monat ist erforderlich')
      .matches(/^(0[1-9]|1[0-2])$/, 'Ungültiger Monat'),
  }),
  kartenAblaufJahr: Yup.string().when('zahlungsMethode', {
    is: 'KREDITKARTE',
    then: () => Yup.string()
      .required('Jahr ist erforderlich')
      .matches(/^\d{2}$/, 'Jahr muss 2 Ziffern haben'),
  }),
});

const PaymentForm = ({ order, onSubmit, loading }) => {
  const [paymentMethod, setPaymentMethod] = useState('');
  
  const initialValues = {
    zahlungsMethode: '',
    kartenNummer: '',
    kartenName: '',
    kartenCVV: '',
    kartenAblaufMonat: '',
    kartenAblaufJahr: '',
  };
  
  const handleSubmit = (values) => {
    const paymentData = {
      ...values,
      betrag: order.gesamtPreis,
    };
    onSubmit(paymentData);
  };
  
  return (
    <Formik
      initialValues={initialValues}
      validationSchema={PaymentSchema}
      onSubmit={handleSubmit}
    >
      {({ errors, touched, values, setFieldValue }) => (
        <Form>
          <Paper elevation={3} sx={{ p: 3, mb: 3 }}>
            <Typography variant="h6" gutterBottom>
              Zahlungsinformationen
            </Typography>
            
            <Box sx={{ mb: 3 }}>
              <Typography variant="body1" gutterBottom>
                Bestellung #{order.id}
              </Typography>
              <Typography variant="h6" color="primary.main">
                Gesamtbetrag: CHF {order.gesamtPreis.toFixed(2)}
              </Typography>
            </Box>
            
            <Divider sx={{ mb: 3 }} />
            
            <Grid container spacing={3}>
              <Grid item xs={12}>
                <FormControl fullWidth error={touched.zahlungsMethode && Boolean(errors.zahlungsMethode)}>
                  <InputLabel id="zahlungsMethode-label">Zahlungsmethode</InputLabel>
                  <Field
                    as={Select}
                    labelId="zahlungsMethode-label"
                    id="zahlungsMethode"
                    name="zahlungsMethode"
                    label="Zahlungsmethode"
                    onChange={(e) => {
                      setFieldValue('zahlungsMethode', e.target.value);
                      setPaymentMethod(e.target.value);
                    }}
                  >
                    <MenuItem value="KREDITKARTE" sx={{ display: 'flex', alignItems: 'center' }}>
                      <CreditCard sx={{ mr: 1 }} /> Kreditkarte
                    </MenuItem>
                    <MenuItem value="BANKUEBERWEISUNG" sx={{ display: 'flex', alignItems: 'center' }}>
                      <AccountBalance sx={{ mr: 1 }} /> Banküberweisung
                    </MenuItem>
                    <MenuItem value="RECHNUNG" sx={{ display: 'flex', alignItems: 'center' }}>
                      <Receipt sx={{ mr: 1 }} /> Rechnung
                    </MenuItem>
                  </Field>
                  {touched.zahlungsMethode && errors.zahlungsMethode && (
                    <FormHelperText>{errors.zahlungsMethode}</FormHelperText>
                  )}
                </FormControl>
              </Grid>
              
              {paymentMethod === 'KREDITKARTE' && (
                <>
                  <Grid item xs={12}>
                    <Field
                      as={TextField}
                      fullWidth
                      id="kartenNummer"
                      name="kartenNummer"
                      label="Kartennummer"
                      variant="outlined"
                      error={touched.kartenNummer && Boolean(errors.kartenNummer)}
                      helperText={touched.kartenNummer && errors.kartenNummer}
                      inputProps={{ maxLength: 16 }}
                    />
                  </Grid>
                  <Grid item xs={12}>
                    <Field
                      as={TextField}
                      fullWidth
                      id="kartenName"
                      name="kartenName"
                      label="Name auf der Karte"
                      variant="outlined"
                      error={touched.kartenName && Boolean(errors.kartenName)}
                      helperText={touched.kartenName && errors.kartenName}
                    />
                  </Grid>
                  <Grid item xs={6}>
                    <Grid container spacing={2}>
                      <Grid item xs={6}>
                        <Field
                          as={TextField}
                          fullWidth
                          id="kartenAblaufMonat"
                          name="kartenAblaufMonat"
                          label="Monat"
                          placeholder="MM"
                          variant="outlined"
                          error={touched.kartenAblaufMonat && Boolean(errors.kartenAblaufMonat)}
                          helperText={touched.kartenAblaufMonat && errors.kartenAblaufMonat}
                          inputProps={{ maxLength: 2 }}
                        />
                      </Grid>
                      <Grid item xs={6}>
                        <Field
                          as={TextField}
                          fullWidth
                          id="kartenAblaufJahr"
                          name="kartenAblaufJahr"
                          label="Jahr"
                          placeholder="JJ"
                          variant="outlined"
                          error={touched.kartenAblaufJahr && Boolean(errors.kartenAblaufJahr)}
                          helperText={touched.kartenAblaufJahr && errors.kartenAblaufJahr}
                          inputProps={{ maxLength: 2 }}
                        />
                      </Grid>
                    </Grid>
                  </Grid>
                  <Grid item xs={6}>
                    <Field
                      as={TextField}
                      fullWidth
                      id="kartenCVV"
                      name="kartenCVV"
                      label="CVV"
                      variant="outlined"
                      error={touched.kartenCVV && Boolean(errors.kartenCVV)}
                      helperText={touched.kartenCVV && errors.kartenCVV}
                      inputProps={{ maxLength: 3 }}
                    />
                  </Grid>
                </>
              )}
              
              {paymentMethod === 'BANKUEBERWEISUNG' && (
                <Grid item xs={12}>
                  <Typography variant="body2" sx={{ mb: 1 }}>
                    Bitte verwenden Sie die folgenden Informationen für die Überweisung:
                  </Typography>
                  <Box sx={{ p: 2, bgcolor: 'grey.50', borderRadius: 1 }}>
                    <Typography variant="body2">
                      <strong>Empfänger:</strong> Mensa App GmbH
                    </Typography>
                    <Typography variant="body2">
                      <strong>IBAN:</strong> CH93 0076 2011 6238 5295 7
                    </Typography>
                    <Typography variant="body2">
                      <strong>BIC/SWIFT:</strong> POFICHBEXXX
                    </Typography>
                    <Typography variant="body2">
                      <strong>Verwendungszweck:</strong> Bestellung #{order.id}
                    </Typography>
                    <Typography variant="body2">
                      <strong>Betrag:</strong> CHF {order.gesamtPreis.toFixed(2)}
                    </Typography>
                  </Box>
                </Grid>
              )}
              
              {paymentMethod === 'RECHNUNG' && (
                <Grid item xs={12}>
                  <Typography variant="body2">
                    Sie erhalten eine Rechnung per E-Mail. Bitte bezahlen Sie diese innerhalb von 10 Tagen.
                  </Typography>
                </Grid>
              )}
              
              <Grid item xs={12}>
                <Button
                  type="submit"
                  fullWidth
                  variant="contained"
                  color="primary"
                  disabled={loading || !paymentMethod}
                  sx={{ py: 1.5, mt: 2 }}
                  startIcon={loading && <CircularProgress size={20} color="inherit" />}
                >
                  {loading ? 'Wird verarbeitet...' : 'Bezahlen'}
                </Button>
              </Grid>
            </Grid>
          </Paper>
        </Form>
      )}
    </Formik>
  );
};

export default PaymentForm;
