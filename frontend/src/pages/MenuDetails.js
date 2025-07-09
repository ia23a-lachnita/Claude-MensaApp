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
  Tabs,
  Tab,
} from '@mui/material';
import {
  Restaurant as RestaurantIcon,
  LocalBar as LocalBarIcon
} from '@mui/icons-material';
import { fetchMenuByDate } from '../store/menu/menuActions';
import Loading from '../components/common/Loading';
import ErrorMessage from '../components/common/ErrorMessage';
import DishCard from '../components/menu/DishCard';
import DrinkCard from '../components/menu/DrinkCard';
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
  const [filteredDrinks, setFilteredDrinks] = useState([]);
  const [tabValue, setTabValue] = useState(0); // 0 = dishes, 1 = drinks

  useEffect(() => {
    dispatch(fetchMenuByDate(currentDate));
  }, [dispatch, currentDate]);

  useEffect(() => {
    if (menuplan) {
      if (menuplan.gerichte) {
        setFilteredDishes(menuplan.gerichte);
      }
      if (menuplan.getraenke) {
        setFilteredDrinks(menuplan.getraenke);
      }
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

  const handleTabChange = (event, newValue) => {
    setTabValue(newValue);
  };

  const handleFilterChange = (filters) => {
    if (!menuplan) return;

    // Filter dishes
    if (menuplan.gerichte) {
      const filteredDishesResult = menuplan.gerichte.filter(gericht => {
        const matchesSearch = filters.search ?
            gericht.name.toLowerCase().includes(filters.search.toLowerCase()) ||
            (gericht.beschreibung && gericht.beschreibung.toLowerCase().includes(filters.search.toLowerCase())) :
            true;

        const matchesVegetarian = filters.onlyVegetarian ? gericht.vegetarisch : true;
        const matchesVegan = filters.onlyVegan ? gericht.vegan : true;
        const matchesPrice = filters.maxPrice ? gericht.preis <= parseFloat(filters.maxPrice) : true;
        const matchesAllergenes = filters.allergens.length > 0 ?
            !filters.allergens.some(allergen =>
                gericht.allergene && gericht.allergene.includes(allergen)
            ) : true;

        return matchesSearch && matchesVegetarian && matchesVegan && matchesPrice && matchesAllergenes;
      });
      setFilteredDishes(filteredDishesResult);
    }

    // Filter drinks
    if (menuplan.getraenke) {
      const filteredDrinksResult = menuplan.getraenke.filter(getraenk => {
        const matchesSearch = filters.search ?
            getraenk.name.toLowerCase().includes(filters.search.toLowerCase()) ||
            (getraenk.beschreibung && getraenk.beschreibung.toLowerCase().includes(filters.search.toLowerCase())) :
            true;

        const matchesPrice = filters.maxPrice ? getraenk.preis <= parseFloat(filters.maxPrice) : true;
        const matchesAvailability = getraenk.verfuegbar; // Only show available drinks

        return matchesSearch && matchesPrice && matchesAvailability;
      });
      setFilteredDrinks(filteredDrinksResult);
    }
  };

  const renderContent = () => {
    if (loading) return <Loading message="Menü wird geladen..." />;
    if (error) return <ErrorMessage message={error} onRetry={() => dispatch(fetchMenuByDate(currentDate))} />;

    if (menuplan && ((menuplan.gerichte && menuplan.gerichte.length > 0) || (menuplan.getraenke && menuplan.getraenke.length > 0))) {
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
                <Paper sx={{ mb: 2 }}>
                  <Tabs
                      value={tabValue}
                      onChange={handleTabChange}
                      sx={{ borderBottom: 1, borderColor: 'divider' }}
                  >
                    <Tab
                        icon={<RestaurantIcon />}
                        label={`Gerichte (${filteredDishes.length})`}
                        iconPosition="start"
                    />
                    <Tab
                        icon={<LocalBarIcon />}
                        label={`Getränke (${filteredDrinks.length})`}
                        iconPosition="start"
                    />
                  </Tabs>
                </Paper>

                {/* Dishes Tab */}
                {tabValue === 0 && (
                    <>
                      {filteredDishes.length > 0 ? (
                          <Grid container spacing={3}>
                            {filteredDishes.map(gericht => (
                                <Grid item xs={12} sm={6} md={4} key={gericht.id}>
                                  <DishCard gericht={gericht} menuDate={currentDate} />
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
                    </>
                )}

                {/* Drinks Tab */}
                {tabValue === 1 && (
                    <>
                      {filteredDrinks.length > 0 ? (
                          <Grid container spacing={3}>
                            {filteredDrinks.map(getraenk => (
                                <Grid item xs={12} sm={6} md={4} key={getraenk.id}>
                                  <DrinkCard getraenk={getraenk} menuDate={currentDate} />
                                </Grid>
                            ))}
                          </Grid>
                      ) : (
                          <Paper sx={{ p: 3, textAlign: 'center' }}>
                            <Typography variant="h6" color="text.secondary">
                              {menuplan.getraenke && menuplan.getraenke.length > 0
                                  ? 'Keine passenden Getränke gefunden'
                                  : 'Keine Getränke für heute verfügbar'}
                            </Typography>
                            {menuplan.getraenke && menuplan.getraenke.length > 0 && (
                                <Button
                                    variant="outlined"
                                    sx={{ mt: 2 }}
                                    onClick={() => handleFilterChange({})}
                                >
                                  Filter zurücksetzen
                                </Button>
                            )}
                          </Paper>
                      )}
                    </>
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
