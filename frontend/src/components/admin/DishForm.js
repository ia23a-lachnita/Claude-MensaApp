import React, { useState, useEffect } from 'react';
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
  Chip,
  IconButton,
  Divider,
  CircularProgress,
} from '@mui/material';
import {
  Save as SaveIcon,
  ArrowBack as ArrowBackIcon,
  Add as AddIcon,
  Delete as DeleteIcon,
} from '@mui/icons-material';

const DishSchema = Yup.object().shape({
  name: Yup.string()
    .required('Name ist erforderlich')
    .max(100, 'Name darf maximal 100 Zeichen lang sein'),
  beschreibung: Yup.string()
    .max(1000, 'Beschreibung darf maximal 1000 Zeichen lang sein'),
  preis: Yup.number()
    .required('Preis ist erforderlich')
    .positive('Preis muss positiv sein')
    .max(100, 'Preis darf maximal 100 CHF sein'),
  vegetarisch: Yup.boolean(),
  vegan: Yup.boolean(),
  zutaten: Yup.array().of(Yup.string()),
  allergene: Yup.array().of(Yup.string()),
  bildUrl: Yup.string().url('Bitte geben Sie eine gültige URL ein').nullable(),
});

const DishForm = ({ dish, onSave, loading, isEdit }) => {
  const [newZutat, setNewZutat] = useState('');
  const [newAllergen, setNewAllergen] = useState('');
  
  const initialValues = {
    name: '',
    beschreibung: '',
    preis: '',
    vegetarisch: false,
    vegan: false,
    zutaten: [],
    allergene: [],
    bildUrl: '',
  };
  
  useEffect(() => {
    if (dish) {
      // Felder aus dem dish-Objekt übernehmen, falls vorhanden
      Object.keys(initialValues).forEach(key => {
        if (dish[key] !== undefined) {
          initialValues[key] = dish[key];
        }
      });
    }
  }, [dish]);
  
  const handleSubmit = (values) => {
    onSave(values);
  };
  
  return (
    <Formik
      initialValues={dish || initialValues}
      validationSchema={DishSchema}
      onSubmit={handleSubmit}
      enableReinitialize
    >
      {({ values, errors, touched, setFieldValue }) => (
        <Form>
          <Paper sx={{ p: 3, mb: 3 }}>
            <Typography variant="h6" component="h2" gutterBottom>
              {isEdit ? 'Gericht bearbeiten' : 'Neues Gericht erstellen'}
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
                        // Wenn vegetarisch abgewählt wird, auch vegan abwählen
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
                        // Wenn vegan ausgewählt wird, auch vegetarisch auswählen
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
              Zutaten
            </Typography>
            
            <Box sx={{ display: 'flex', mb: 2 }}>
              <TextField
                fullWidth
                label="Neue Zutat"
                variant="outlined"
                value={newZutat}
                onChange={(e) => setNewZutat(e.target.value)}
                size="small"
              />
              <Button
                variant="contained"
                color="primary"
                startIcon={<AddIcon />}
                onClick={() => {
                  if (newZutat.trim()) {
                    setFieldValue('zutaten', [...values.zutaten, newZutat.trim()]);
                    setNewZutat('');
                  }
                }}
                disabled={!newZutat.trim()}
                sx={{ ml: 1 }}
              >
                Hinzufügen
              </Button>
            </Box>
            
            <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 1 }}>
              <FieldArray name="zutaten">
                {({ remove }) => (
                  <>
                    {values.zutaten.length > 0 ? (
                      values.zutaten.map((zutat, index) => (
                        <Chip
                          key={index}
                          label={zutat}
                          onDelete={() => remove(index)}
                          color="primary"
                          variant="outlined"
                        />
                      ))
                    ) : (
                      <Typography variant="body2" color="text.secondary">
                        Keine Zutaten hinzugefügt
                      </Typography>
                    )}
                  </>
                )}
              </FieldArray>
            </Box>
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
                        Keine Allergene hinzugefügt
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

export default DishForm;
