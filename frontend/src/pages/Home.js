import React, { useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Link as RouterLink } from 'react-router-dom';
import {
  Box,
  Typography,
  Button,
  Grid,
  Card,
  CardContent,
  CardMedia,
  Container,
  Paper,
} from '@mui/material';
import {
  Restaurant as RestaurantIcon,
  Event as EventIcon,
  ShoppingCart as ShoppingCartIcon,
} from '@mui/icons-material';
import { fetchTodayMenu, fetchWeeklyMenu } from '../store/menu/menuActions';
import Loading from '../components/common/Loading';
import ErrorMessage from '../components/common/ErrorMessage';
import MenuCard from '../components/menu/MenuCard';
import { getNextMenuPlans } from '../utils/menuUtils';

const Home = () => {
  const dispatch = useDispatch();
  const { menuplan, weeklyMenus, loading, error } = useSelector(state => state.menu);
  
  useEffect(() => {
    dispatch(fetchTodayMenu());
    dispatch(fetchWeeklyMenu(new Date()));
  }, [dispatch]);
  
  const renderMenuPreview = () => {
    if (loading) return <Loading message="Menü wird geladen..." />;
    if (error) return <ErrorMessage message={error} onRetry={() => dispatch(fetchTodayMenu())} />;
    
    if (menuplan) {
      return (
        <Box sx={{ mb: 4 }}>
          <Typography variant="h5" component="h2" gutterBottom>
            Heutiges Menü
          </Typography>
          <MenuCard menuplan={menuplan} />
          <Box sx={{ mt: 2, textAlign: 'center' }}>
            <Button
              variant="contained"
              color="primary"
              component={RouterLink}
              to={`/menu/${menuplan.datum}`}
              startIcon={<RestaurantIcon />}
            >
              Vollständiges Menü anzeigen
            </Button>
          </Box>
        </Box>
      );
    }
    
    return (
      <Box sx={{ textAlign: 'center', py: 4 }}>
        <Typography variant="h6" color="text.secondary">
          Kein Menü für heute verfügbar
        </Typography>
        <Button
          variant="contained"
          color="primary"
          component={RouterLink}
          to="/menu"
          sx={{ mt: 2 }}
        >
          Menüplan anzeigen
        </Button>
      </Box>
    );
  };
  
  const renderWeeklyPreview = () => {
    if (weeklyMenus && weeklyMenus.length > 0) {
      // Hole die nächsten 3 Menüpläne ab heute (sortiert)
      const nextDays = getNextMenuPlans(weeklyMenus, 3);
      
      return (
        <Box sx={{ mb: 4 }}>
          <Typography variant="h5" component="h2" gutterBottom>
            Kommende Menüs
          </Typography>
          <Grid container spacing={3}>
            {nextDays.map(menu => (
              <Grid item xs={12} sm={6} md={4} key={menu.id}>
                <MenuCard menuplan={menu} compact />
              </Grid>
            ))}
          </Grid>
          <Box sx={{ mt: 2, textAlign: 'center' }}>
            <Button
              variant="outlined"
              color="primary"
              component={RouterLink}
              to="/menu"
              startIcon={<EventIcon />}
            >
              Vollständigen Menüplan anzeigen
            </Button>
          </Box>
        </Box>
      );
    }
    
    return null;
  };
  
  return (
    <Box>
      {/* Hero Section */}
      <Paper
        sx={{
          position: 'relative',
          color: 'white',
          mb: 4,
          backgroundSize: 'cover',
          backgroundRepeat: 'no-repeat',
          backgroundPosition: 'center',
          backgroundImage: 'url(https://source.unsplash.com/random?food)',
          height: '400px',
          display: 'flex',
          alignItems: 'center',
        }}
      >
        <Box
          sx={{
            position: 'absolute',
            top: 0,
            bottom: 0,
            right: 0,
            left: 0,
            backgroundColor: 'rgba(0,0,0,.6)',
          }}
        />
        <Container sx={{ position: 'relative', p: 4 }}>
          <Box maxWidth="sm">
            <Typography variant="h3" component="h1" gutterBottom>
              Willkommen in unserer Mensa
            </Typography>
            <Typography variant="h5" paragraph>
              Entdecken, bestellen und geniessen Sie unser vielfältiges Angebot
            </Typography>
            <Button
              variant="contained"
              size="large"
              component={RouterLink}
              to="/menu"
              startIcon={<ShoppingCartIcon />}
            >
              Jetzt bestellen
            </Button>
          </Box>
        </Container>
      </Paper>
      
      {renderMenuPreview()}
      
      {renderWeeklyPreview()}
      
      {/* Features */}
      <Typography variant="h5" component="h2" gutterBottom>
        Unsere Vorteile
      </Typography>
      <Grid container spacing={3}>
        <Grid item xs={12} md={4}>
          <Card elevation={3}>
            <CardContent>
              <Typography variant="h6" component="h3" gutterBottom>
                Vorbestellung
              </Typography>
              <Typography variant="body2" color="text.secondary">
                Bestellen Sie Ihr Essen im Voraus und sparen Sie wertvolle Zeit. Kein Anstehen mehr in der Mittagspause.
              </Typography>
            </CardContent>
          </Card>
        </Grid>
        <Grid item xs={12} md={4}>
          <Card elevation={3}>
            <CardContent>
              <Typography variant="h6" component="h3" gutterBottom>
                Vielfältiges Angebot
              </Typography>
              <Typography variant="body2" color="text.secondary">
                Geniessen Sie täglich wechselnde Menüs mit vegetarischen und veganen Optionen. Für jeden Geschmack ist etwas dabei.
              </Typography>
            </CardContent>
          </Card>
        </Grid>
        <Grid item xs={12} md={4}>
          <Card elevation={3}>
            <CardContent>
              <Typography variant="h6" component="h3" gutterBottom>
                Einfache Bezahlung
              </Typography>
              <Typography variant="body2" color="text.secondary">
                Bezahlen Sie bequem und sicher online. Verschiedene Zahlungsmethoden stehen zur Auswahl.
              </Typography>
            </CardContent>
          </Card>
        </Grid>
      </Grid>
    </Box>
  );
};

export default Home;
