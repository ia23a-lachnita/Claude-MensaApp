import React, { useEffect, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { useParams, useNavigate } from 'react-router-dom';
import {
  Box,
  Grid,
  Typography,
  Button,
  Paper,
  Divider,
  CircularProgress,
} from '@mui/material';
import { fetchMenuByDate } from '../store/menu/menuActions';
import { addToCart } from '../store/cart/cartSlice';
import Loading from '../components/common/Loading';
import ErrorMessage from '../components/common/ErrorMessage';
import DishCard from '../components/menu/DishCard';
import DateSelector from '../components/menu/DateSelector';
import FilterControls from '../components/menu/FilterControls';
import { formatDate } from '../utils/dateUtils';

const MenuDetails = () => {
  const { date } = useParams();
  const dispatch = useDispatch();
  const navigate = useNavigate();
  const { menuplan, loading, error } = useSelector(state => state.menu);
  const [currentDate, setCurrentDate] = useState(date || new Date().toISOString().split('T')[0]);
  const [filteredDishes, setFilteredDishes] = useState([]);
  
  useEffect(() => {
    dispatch(fetchMenuByDate(currentDate));
  }, [dispatch, currentDate]);
  
  useEffect(() => {
    if (menuplan && menuplan.gerichte) {
      setFilteredDishes(menuplan.gerichte);
    }
  }, [menuplan]);
  
  useEffect(() => {
    if (date && date !== currentDate) {
      setCurrentDate(date);
    }
  }, [date]);
  
  const handleDateChange = (date) => {
    setCurrentDate(date);
    navigate(`/menu/${date}`);
  };
  
  const handleFilterChange = (filters) => {
    if (!menuplan || !menuplan.gerichte) return;
    
    const filtered = menuplan.gerichte.filter(gericht => {
      // Filtern nach Suchbegriff
      const matchesSearch = filters.search ? 
        gericht.name.toLowerCase().includes(filters.search.toLowerCase()) ||
        (gericht.beschreibung && gericht.beschreibung.toLowerCase().includes(filters.search.toLowerCase())) : 
        true;
      
      // Filtern nach vegetarisch
      const matchesVegetarian = filters.onlyVegetarian ? gericht.vegetarisch : true;
      
      // Filtern nach vegan
      const matchesVegan = filters.onlyVegan ? gericht.vegan : true;
      
      // Filtern nach Maximalpreis
      const matchesPrice = filters.maxPrice ? gericht.preis <= parseFloat(filters.maxPrice) : true;
      
      // Filtern nach Allergenen
      const matchesAllergenes = filters.allergens.length > 0 ?
        !filters.allergens.some(allergen => 
          gericht.allergene && gericht.allergene.includes(allergen)
        ) : true;
      
      return matchesSearch && matchesVegetarian && matchesVegan && matchesPrice && matchesAllergenes;
    });
    
    setFilteredDishes(filtered);
  };
  
  const renderContent = () => {
    if (loading) return <Loading message="Menü wird geladen..." />;
    if (error) return <ErrorMessage message={error} onRetry={() => dispatch(fetchMenuByDate(currentDate))} />;
    
    if (menuplan && menuplan.gerichte && menuplan.gerichte.length > 0) {
      return (
        <>
          <Box sx={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', mb: 3 }}>
            <Typography variant="h5" component="h1">
              Speisekarte für {formatDate(menuplan.datum)}
            </Typography>
          </Box>
          
          <Grid container spacing={3}>
            <Grid item xs={12} md={3}>
              <FilterControls onFilterChange={handleFilterChange} />
            </Grid>
            
            <Grid item xs={12} md={9}>
              {filteredDishes.length > 0 ? (
                <Grid container spacing={3}>
                  {filteredDishes.map(gericht => (
                    <Grid item xs={12} sm={6} md={4} key={gericht.id}>
                      <DishCard gericht={gericht} />
                    </Grid>
                  ))}
                </Grid>
              ) : (
                <Paper sx={{ p: 3, textAlign: 'center' }}>
                  <Typography variant="h6" color="text.secondary">
                    Keine passenden Gerichte gefunden
                  </Typography>
                  <Button 
                    variant="outlined" 
                    sx={{ mt: 2 }}
                    onClick={() => handleFilterChange({})}
                  >
                    Filter zurücksetzen
                  </Button>
                </Paper>
              )}
            </Grid>
          </Grid>
        </>
      );
    }
    
    return (
      <Paper sx={{ p: 3, textAlign: 'center' }}>
        <Typography variant="h6" color="text.secondary">
          Kein Menü für dieses Datum verfügbar
        </Typography>
        <Button 
          variant="outlined" 
          sx={{ mt: 2 }}
          onClick={() => navigate('/menu')}
        >
          Zur Menüübersicht
        </Button>
      </Paper>
    );
  };
  
  return (
    <Box>
      <DateSelector selectedDate={currentDate} onChange={handleDateChange} />
      
      {renderContent()}
    </Box>
  );
};

export default MenuDetails;
