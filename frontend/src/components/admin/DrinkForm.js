import React, { useState } from 'react';
import { Formik, Form, Field, FieldArray } from 'formik';
import * as Yup from 'yup';
import {
  Paper,
  Typography,
  Box,
  Button,
  Grid,
  TextField,
  FormControlLabel,
  Checkbox,
  CircularProgress,
  Chip,
} from '@mui/material';
import {
  Save as SaveIcon,
  ArrowBack as ArrowBackIcon,
  Add as AddIcon,
} from '@mui/icons-material';

const DrinkSchema = Yup.object().shape({
  name: Yup.string()
    .required('Name ist erforderlich')
    .max(100, 'Name darf maximal 100 Zeichen lang sein'),
  beschreibung: Yup.string()
    .required('Beschreibung ist erforderlich')
    .max(1000, 'Beschreibung darf maximal 1000 Zeichen lang sein'),
  preis: Yup.number()
    .required('Preis ist erforderlich')
    .positive('Preis muss positiv sein')
    .max(100, 'Preis darf maximal 100 CHF sein'),
  vorrat: Yup.number()
    .required('Vorrat ist erforderlich')
    .min(0, 'Vorrat darf nicht negativ sein')
    .integer('Vorrat muss eine ganze Zahl sein'),
  vegetarisch: Yup.boolean(),
  vegan: Yup.boolean(),
  allergene: Yup.array().of(Yup.string()).min(1, 'Mindestens ein Allergen muss angegeben werden'),
  verfuegbar: Yup.boolean(),
  bildUrl: Yup.string().url('Bitte geben Sie eine gültige URL ein').nullable(),
});

const DrinkForm = ({ drink, onSave, loading, isEdit }) => {
  const [newAllergen, setNewAllergen] = useState('');
  
  const initialValues = {
    name: '',
    beschreibung: '',
    preis: '',
    vorrat: 0,
    vegetarisch: false,
    vegan: false,
    allergene: [],
    verfuegbar: true,
    bildUrl: '',
  };
  
  const handleSubmit = (values) => {
    onSave(values);
  };
  
  return (
    <Formik
      initialValues={drink || initialValues}
      validationSchema={DrinkSchema}
      onSubmit={handleSubmit}
      enableReinitialize
    >
      {({ values, errors, touched, setFieldValue }) => (
        <Form>
          <Paper sx={{ p: 3, mb: 3 }}>
            <Typography variant="h6" component="h2" gutterBottom>
              {isEdit ? 'Getränk bearbeiten' : 'Neues Getränk erstellen'}
            </Typography>
            
            <Grid container spacing={3}>
              <Grid item xs={12}>
                <Field
                  as={TextField}
                  fullWidth
                  id="name"
                  name="name"
                  label="Name"
                  variant="outlined"
                  error={touched.name && Boolean(errors.name)}
                  helperText={touched.name && errors.name}
                  required
                />
              </Grid>
              
              <Grid item xs={12}>
                <Field
                  as={TextField}
                  fullWidth
                  id="beschreibung"
                  name="beschreibung"
                  label="Beschreibung"
                  variant="outlined"
                  multiline
                  rows={3}
                  error={touched.beschreibung && Boolean(errors.beschreibung)}
                  helperText={touched.beschreibung && errors.beschreibung}
                  required
                />
              </Grid>
              
              <Grid item xs={12} sm={4}>
                <Field
                  as={TextField}
                  fullWidth
                  id="preis"
                  name="preis"
                  label="Preis (CHF)"
                  variant="outlined"
                  type="number"
                  InputProps={{ inputProps: { min: 0, step: 0.1 } }}
                  error={touched.preis && Boolean(errors.preis)}
                  helperText={touched.preis && errors.preis}
                  required
                />
              </Grid>
              
              <Grid item xs={12} sm={4}>
                <Field
                  as={TextField}
                  fullWidth
                  id="vorrat"
                  name="vorrat"
                  label="Vorrat"
                  variant="outlined"
                  type="number"
                  InputProps={{ inputProps: { min: 0, step: 1 } }}
                  error={touched.vorrat && Boolean(errors.vorrat)}
                  helperText={touched.vorrat && errors.vorrat}
                  required
                />
              </Grid>
              
              <Grid item xs={12} sm={4}>
                <FormControlLabel
                  control={
                    <Field
                      as={Checkbox}
                      id="verfuegbar"
                      name="verfuegbar"
                      color="success"
                    />
                  }
                  label="Verfügbar"
                />
              </Grid>
              
              <Grid item xs={12} sm={4}>
                <FormControlLabel
                  control={
                    <Field
                      as={Checkbox}
                      id="vegetarisch"
                      name="vegetarisch"
                      color="success"
                      checked={values.vegetarisch}
                      onChange={(e) => {
                        setFieldValue('vegetarisch', e.target.checked);
                        if (!e.target.checked) {
                          setFieldValue('vegan', false);
                        }
                      }}
                    />
                  }
                  label="Vegetarisch"
                />
              </Grid>
              
              <Grid item xs={12} sm={4}>
                <FormControlLabel
                  control={
                    <Field
                      as={Checkbox}
                      id="vegan"
                      name="vegan"
                      color="success"
                      checked={values.vegan}
                      onChange={(e) => {
                        setFieldValue('vegan', e.target.checked);
                        if (e.target.checked) {
                          setFieldValue('vegetarisch', true);
                        }
                      }}
                      disabled={!values.vegetarisch}
                    />
                  }
                  label="Vegan"
                />
              </Grid>
              
              <Grid item xs={12}>
                <Field
                  as={TextField}
                  fullWidth
                  id="bildUrl"
                  name="bildUrl"
                  label="Bild-URL"
                  variant="outlined"
                  error={touched.bildUrl && Boolean(errors.bildUrl)}
                  helperText={touched.bildUrl && errors.bildUrl}
                />
              </Grid>
            </Grid>
          </Paper>
          
          <Paper sx={{ p: 3, mb: 3 }}>
            <Typography variant="h6" component="h3" gutterBottom>
              Allergene
            </Typography>
            
            <Box sx={{ display: 'flex', mb: 2 }}>
              <TextField
                fullWidth
                label="Neues Allergen"
                variant="outlined"
                value={newAllergen}
                onChange={(e) => setNewAllergen(e.target.value)}
                size="small"
                error={touched.allergene && Boolean(errors.allergene)}
                helperText={touched.allergene && errors.allergene}
              />
              <Button
                variant="contained"
                color="primary"
                startIcon={<AddIcon />}
                onClick={() => {
                  if (newAllergen.trim()) {
                    setFieldValue('allergene', [...values.allergene, newAllergen.trim()]);
                    setNewAllergen('');
                  }
                }}
                disabled={!newAllergen.trim()}
                sx={{ ml: 1 }}
              >
                Hinzufügen
              </Button>
            </Box>
            
            <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 1 }}>
              <FieldArray name="allergene">
                {({ remove }) => (
                  <>
                    {values.allergene.length > 0 ? (
                      values.allergene.map((allergen, index) => (
                        <Chip
                          key={index}
                          label={allergen}
                          onDelete={() => remove(index)}
                          color="error"
                          variant="outlined"
                        />
                      ))
                    ) : (
                      <Typography variant="body2" color="text.secondary">
                        Keine Allergene hinzugefügt (mindestens eines erforderlich)
                      </Typography>
                    )}
                  </>
                )}
              </FieldArray>
            </Box>
          </Paper>
          
          <Box sx={{ display: 'flex', justifyContent: 'space-between' }}>
            <Button
              variant="outlined"
              startIcon={<ArrowBackIcon />}
              onClick={() => window.history.back()}
            >
              Zurück
            </Button>
            
            <Button
              type="submit"
              variant="contained"
              color="primary"
              startIcon={loading ? <CircularProgress size={20} color="inherit" /> : <SaveIcon />}
              disabled={loading}
            >
              {loading ? 'Wird gespeichert...' : 'Speichern'}
            </Button>
          </Box>
        </Form>
      )}
    </Formik>
  );
};

export default DrinkForm;
