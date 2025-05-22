import React, { useState } from 'react';
import {
  Box,
  FormGroup,
  FormControlLabel,
  Checkbox,
  TextField,
  InputAdornment,
  IconButton,
  Button,
  Chip,
  Paper,
  Typography,
  Divider,
  Collapse,
} from '@mui/material';
import {
  Search as SearchIcon,
  Clear as ClearIcon,
  ExpandMore as ExpandMoreIcon,
} from '@mui/icons-material';
import { styled } from '@mui/material/styles';

const ExpandButton = styled(Button)(({ theme, expanded }) => ({
  marginTop: theme.spacing(1),
  marginBottom: theme.spacing(1),
  '& .MuiButton-endIcon': {
    transition: 'transform 0.2s',
    transform: expanded ? 'rotate(180deg)' : 'rotate(0deg)',
  },
}));

const FilterControls = ({ onFilterChange }) => {
  const [filters, setFilters] = useState({
    search: '',
    onlyVegetarian: false,
    onlyVegan: false,
    maxPrice: '',
    allergens: [],
  });
  
  const [expanded, setExpanded] = useState(false);
  const [searchTerm, setSearchTerm] = useState('');
  
  // Common allergens
  const commonAllergens = [
    'Gluten', 
    'Laktose', 
    'Eier', 
    'Nüsse', 
    'Erdnüsse', 
    'Soja', 
    'Fisch', 
    'Krebstiere', 
    'Sellerie', 
    'Senf'
  ];
  
  const handleSearchChange = (event) => {
    setSearchTerm(event.target.value);
  };
  
  const handleSearchSubmit = () => {
    handleFilterChange('search', searchTerm);
  };
  
  const handleSearchClear = () => {
    setSearchTerm('');
    handleFilterChange('search', '');
  };
  
  const handleFilterChange = (filterName, value) => {
    const newFilters = { ...filters, [filterName]: value };
    setFilters(newFilters);
    onFilterChange(newFilters);
  };
  
  const handleAllergenToggle = (allergen) => {
    const currentAllergens = [...filters.allergens];
    const allergenIndex = currentAllergens.indexOf(allergen);
    
    if (allergenIndex === -1) {
      currentAllergens.push(allergen);
    } else {
      currentAllergens.splice(allergenIndex, 1);
    }
    
    handleFilterChange('allergens', currentAllergens);
  };
  
  const handleAllergenClear = () => {
    handleFilterChange('allergens', []);
  };
  
  const handleExpand = () => {
    setExpanded(!expanded);
  };
  
  const handleKeyDown = (event) => {
    if (event.key === 'Enter') {
      handleSearchSubmit();
    }
  };
  
  return (
    <Paper elevation={2} sx={{ p: 2, mb: 3 }}>
      <Typography variant="h6" component="h2" gutterBottom>
        Filter
      </Typography>
      
      <Box sx={{ mb: 2 }}>
        <TextField
          fullWidth
          placeholder="Gerichte suchen..."
          value={searchTerm}
          onChange={handleSearchChange}
          onKeyDown={handleKeyDown}
          variant="outlined"
          size="small"
          InputProps={{
            startAdornment: (
              <InputAdornment position="start">
                <SearchIcon />
              </InputAdornment>
            ),
            endAdornment: searchTerm && (
              <InputAdornment position="end">
                <IconButton
                  aria-label="clear search"
                  onClick={handleSearchClear}
                  edge="end"
                >
                  <ClearIcon />
                </IconButton>
              </InputAdornment>
            ),
          }}
        />
      </Box>
      
      <FormGroup row>
        <FormControlLabel
          control={
            <Checkbox
              checked={filters.onlyVegetarian}
              onChange={(e) => handleFilterChange('onlyVegetarian', e.target.checked)}
              color="success"
            />
          }
          label="Vegetarisch"
        />
        <FormControlLabel
          control={
            <Checkbox
              checked={filters.onlyVegan}
              onChange={(e) => handleFilterChange('onlyVegan', e.target.checked)}
              color="success"
            />
          }
          label="Vegan"
        />
      </FormGroup>
      
      <ExpandButton
        fullWidth
        endIcon={<ExpandMoreIcon />}
        onClick={handleExpand}
        expanded={expanded}
        sx={{ justifyContent: 'space-between' }}
      >
        Erweiterte Filter
      </ExpandButton>
      
      <Collapse in={expanded}>
        <Divider sx={{ my: 1 }} />
        
        <Box sx={{ mt: 2 }}>
          <Typography variant="subtitle2" gutterBottom>
            Maximalpreis (CHF)
          </Typography>
          <TextField
            type="number"
            value={filters.maxPrice}
            onChange={(e) => handleFilterChange('maxPrice', e.target.value)}
            variant="outlined"
            size="small"
            fullWidth
            inputProps={{ min: 0, step: 0.5 }}
          />
        </Box>
        
        <Box sx={{ mt: 2 }}>
          <Typography variant="subtitle2" gutterBottom>
            Allergene ausschliessen
          </Typography>
          <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 0.5 }}>
            {commonAllergens.map((allergen) => (
              <Chip
                key={allergen}
                label={allergen}
                onClick={() => handleAllergenToggle(allergen)}
                color={filters.allergens.includes(allergen) ? 'primary' : 'default'}
                variant={filters.allergens.includes(allergen) ? 'filled' : 'outlined'}
                sx={{ mb: 1 }}
              />
            ))}
          </Box>
          {filters.allergens.length > 0 && (
            <Button
              variant="text"
              size="small"
              onClick={handleAllergenClear}
              sx={{ mt: 1 }}
            >
              Auswahl zurücksetzen
            </Button>
          )}
        </Box>
      </Collapse>
    </Paper>
  );
};

export default FilterControls;
