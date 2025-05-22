import React, { useState, useEffect } from 'react';
import {
  Paper,
  Typography,
  Box,
  Button,
  Grid,
  Chip,
  List,
  ListItem,
  ListItemText,
  ListItemSecondaryAction,
  IconButton,
  Divider,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  TextField,
  CircularProgress,
} from '@mui/material';
import {
  Add as AddIcon,
  Delete as DeleteIcon,
  Save as SaveIcon,
  ArrowBack as ArrowBackIcon,
} from '@mui/icons-material';
import { DatePicker } from '@mui/x-date-pickers/DatePicker';
import { AdapterDateFns } from '@mui/x-date-pickers/AdapterDateFns';
import { LocalizationProvider } from '@mui/x-date-pickers/LocalizationProvider';
import deLocale from 'date-fns/locale/de';
import { formatDate } from '../../utils/dateUtils';

const MenuForm = ({ menuplan, dishes, onSave, loading, isEdit }) => {
  const [formData, setFormData] = useState({
    datum: null,
    gerichtIds: [],
  });
  const [selectedDishes, setSelectedDishes] = useState([]);
  const [dishDialogOpen, setDishDialogOpen] = useState(false);
  const [searchTerm, setSearchTerm] = useState('');
  
  useEffect(() => {
    if (menuplan) {
      setFormData({
        datum: menuplan.datum,
        gerichtIds: menuplan.gerichte.map(g => g.id),
      });
      setSelectedDishes(menuplan.gerichte);
    } else {
      setFormData({
        datum: new Date(),
        gerichtIds: [],
      });
      setSelectedDishes([]);
    }
  }, [menuplan]);
  
  const handleDateChange = (date) => {
    setFormData({ ...formData, datum: date });
  };
  
  const handleOpenDishDialog = () => {
    setDishDialogOpen(true);
    setSearchTerm('');
  };
  
  const handleCloseDishDialog = () => {
    setDishDialogOpen(false);
  };
  
  const handleAddDish = (dish) => {
    if (!formData.gerichtIds.includes(dish.id)) {
      setFormData({
        ...formData,
        gerichtIds: [...formData.gerichtIds, dish.id],
      });
      setSelectedDishes([...selectedDishes, dish]);
    }
    handleCloseDishDialog();
  };
  
  const handleRemoveDish = (dishId) => {
    setFormData({
      ...formData,
      gerichtIds: formData.gerichtIds.filter(id => id !== dishId),
    });
    setSelectedDishes(selectedDishes.filter(dish => dish.id !== dishId));
  };
  
  const handleSearchChange = (event) => {
    setSearchTerm(event.target.value.toLowerCase());
  };
  
  const handleSubmit = (event) => {
    event.preventDefault();
    onSave(formData);
  };
  
  const filteredDishes = dishes.filter(dish => {
    return (
      dish.name.toLowerCase().includes(searchTerm) ||
      (dish.beschreibung && dish.beschreibung.toLowerCase().includes(searchTerm))
    ) && !formData.gerichtIds.includes(dish.id);
  });
  
  return (
    <form onSubmit={handleSubmit}>
      <Paper sx={{ p: 3, mb: 3 }}>
        <Typography variant="h6" component="h2" gutterBottom>
          {isEdit ? 'Menüplan bearbeiten' : 'Neuen Menüplan erstellen'}
        </Typography>
        
        <Grid container spacing={3}>
          <Grid item xs={12} md={6}>
            <LocalizationProvider dateAdapter={AdapterDateFns} adapterLocale={deLocale}>
              <DatePicker
                label="Datum"
                value={formData.datum ? new Date(formData.datum) : null}
                onChange={handleDateChange}
                sx={{ width: '100%' }}
                slotProps={{
                  textField: {
                    variant: 'outlined',
                    fullWidth: true,
                    required: true,
                    helperText: 'Wählen Sie das Datum für den Menüplan',
                  },
                }}
              />
            </LocalizationProvider>
          </Grid>
        </Grid>
      </Paper>
      
      <Paper sx={{ p: 3, mb: 3 }}>
        <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 2 }}>
          <Typography variant="h6" component="h3">
            Gerichte ({selectedDishes.length})
          </Typography>
          
          <Button
            variant="outlined"
            startIcon={<AddIcon />}
            onClick={handleOpenDishDialog}
          >
            Gericht hinzufügen
          </Button>
        </Box>
        
        {selectedDishes.length > 0 ? (
          <List sx={{ bgcolor: 'background.paper' }}>
            {selectedDishes.map((dish, index) => (
              <React.Fragment key={dish.id}>
                {index > 0 && <Divider />}
                <ListItem>
                  <ListItemText
                    primary={dish.name}
                    secondary={
                      <>
                        <Typography component="span" variant="body2" color="text.primary">
                          CHF {dish.preis.toFixed(2)}
                        </Typography>
                        {' — '}
                        {dish.vegetarisch && 'Vegetarisch'}
                        {dish.vegetarisch && dish.vegan && ' · '}
                        {dish.vegan && 'Vegan'}
                      </>
                    }
                  />
                  <ListItemSecondaryAction>
                    <IconButton edge="end" aria-label="delete" onClick={() => handleRemoveDish(dish.id)}>
                      <DeleteIcon />
                    </IconButton>
                  </ListItemSecondaryAction>
                </ListItem>
              </React.Fragment>
            ))}
          </List>
        ) : (
          <Typography variant="body2" color="text.secondary" sx={{ textAlign: 'center', py: 3 }}>
            Keine Gerichte ausgewählt. Klicken Sie auf "Gericht hinzufügen", um zu beginnen.
          </Typography>
        )}
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
          disabled={loading || formData.gerichtIds.length === 0 || !formData.datum}
        >
          {loading ? 'Wird gespeichert...' : 'Speichern'}
        </Button>
      </Box>
      
      <Dialog
        open={dishDialogOpen}
        onClose={handleCloseDishDialog}
        maxWidth="md"
        fullWidth
      >
        <DialogTitle>Gericht hinzufügen</DialogTitle>
        <DialogContent>
          <TextField
            autoFocus
            margin="dense"
            label="Gerichte durchsuchen"
            type="text"
            fullWidth
            variant="outlined"
            value={searchTerm}
            onChange={handleSearchChange}
            sx={{ mb: 2 }}
          />
          
          <List sx={{ bgcolor: 'background.paper' }}>
            {filteredDishes.length > 0 ? (
              filteredDishes.map((dish, index) => (
                <React.Fragment key={dish.id}>
                  {index > 0 && <Divider />}
                  <ListItem button onClick={() => handleAddDish(dish)}>
                    <ListItemText
                      primary={dish.name}
                      secondary={
                        <>
                          <Typography component="span" variant="body2" color="text.primary">
                            CHF {dish.preis.toFixed(2)}
                          </Typography>
                          {' — '}
                          {dish.beschreibung && dish.beschreibung.length > 60
                            ? `${dish.beschreibung.substring(0, 60)}...`
                            : dish.beschreibung}
                          <Box sx={{ mt: 0.5 }}>
                            {dish.vegetarisch && (
                              <Chip 
                                label="Vegetarisch" 
                                size="small" 
                                color="success" 
                                variant="outlined" 
                                sx={{ mr: 0.5 }}
                              />
                            )}
                            {dish.vegan && (
                              <Chip 
                                label="Vegan" 
                                size="small" 
                                color="success" 
                                sx={{ mr: 0.5 }}
                              />
                            )}
                          </Box>
                        </>
                      }
                    />
                  </ListItem>
                </React.Fragment>
              ))
            ) : (
              <Typography variant="body2" color="text.secondary" sx={{ textAlign: 'center', py: 2 }}>
                Keine passenden Gerichte gefunden
              </Typography>
            )}
          </List>
        </DialogContent>
        <DialogActions>
          <Button onClick={handleCloseDishDialog}>Abbrechen</Button>
        </DialogActions>
      </Dialog>
    </form>
  );
};

export default MenuForm;
