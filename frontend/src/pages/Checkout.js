import React, { useState, useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { useNavigate } from 'react-router-dom';
import {
  Box,
  Grid,
  Typography,
  Button,
  Paper,
  Stepper,
  Step,
  StepLabel,
  CircularProgress,
} from '@mui/material';
import {
  ShoppingCart as ShoppingCartIcon,
  Schedule as ScheduleIcon,
  Payment as PaymentIcon,
  Restaurant as RestaurantIcon,
} from '@mui/icons-material';
import { toast } from 'react-toastify';

import PageTitle from '../components/common/PageTitle';
import CartItem from '../components/cart/CartItem';
import CartSummary from '../components/cart/CartSummary';
import PickupSelector from '../components/cart/PickupSelector';
import EmptyState from '../components/common/EmptyState';
import { bestellungService } from '../services/api';
import { clearCart, selectCartItems, selectCartTotal } from '../store/cart/cartSlice';

const steps = ['Warenkorb', 'Abholzeit', 'Bestellübersicht'];

const Checkout = () => {
  const dispatch = useDispatch();
  const navigate = useNavigate();
  const cartItems = useSelector(selectCartItems);
  const cartTotal = useSelector(selectCartTotal);
  const abholDatum = useSelector(state => state.cart.abholDatum);
  const abholZeit = useSelector(state => state.cart.abholZeit);
  const bemerkungen = useSelector(state => state.cart.bemerkungen);
  
  const [activeStep, setActiveStep] = useState(0);
  const [loading, setLoading] = useState(false);
  
  useEffect(() => {
    // Wenn der Warenkorb leer ist, zurück zum Menü navigieren
    if (cartItems.length === 0 && activeStep !== 0) {
      setActiveStep(0);
    }
  }, [cartItems, activeStep]);
  
  const handleNext = () => {
    const nextStep = activeStep + 1;
    
    // Validieren je nach aktuellem Schritt
    if (activeStep === 0 && cartItems.length === 0) {
      toast.error('Ihr Warenkorb ist leer. Bitte fügen Sie einige Gerichte hinzu.');
      return;
    }
    
    if (activeStep === 1 && (!abholDatum || !abholZeit)) {
      toast.error('Bitte wählen Sie ein Abholdatum und eine Abholzeit.');
      return;
    }
    
    setActiveStep(nextStep);
  };
  
  const handleBack = () => {
    setActiveStep(activeStep - 1);
  };
  
  const handleSubmitOrder = async () => {
    if (cartItems.length === 0) {
      toast.error('Ihr Warenkorb ist leer');
      return;
    }
    
    setLoading(true);
    
    const orderData = {
      abholDatum,
      abholZeit,
      bemerkungen,
      positionen: cartItems.map(item => ({
        gerichtId: item.gericht.id,
        anzahl: item.anzahl
      }))
    };
    
    try {
      const response = await bestellungService.createBestellung(orderData);
      dispatch(clearCart());
      navigate(`/payment/${response.data.id}`);
    } catch (error) {
      const message = error.response?.data?.message || 'Ein Fehler ist aufgetreten';
      toast.error(message);
      setLoading(false);
    }
  };
  
  const renderStepContent = (step) => {
    switch (step) {
      case 0:
        return renderCartStep();
      case 1:
        return renderPickupStep();
      case 2:
        return renderConfirmationStep();
      default:
        return null;
    }
  };
  
  const renderCartStep = () => {
    if (cartItems.length === 0) {
      return (
        <EmptyState
          title="Ihr Warenkorb ist leer"
          message="Fügen Sie einige Gerichte aus dem Menü hinzu, um fortzufahren."
          actionText="Zum Menü"
          onAction={() => navigate('/menu')}
          icon={RestaurantIcon}
        />
      );
    }
    
    return (
      <Grid container spacing={3}>
        <Grid item xs={12} md={8}>
          <Paper sx={{ p: 3, mb: { xs: 3, md: 0 } }}>
            <Typography variant="h6" component="h2" gutterBottom>
              Warenkorb
            </Typography>
            
            <Box sx={{ mt: 2 }}>
              {cartItems.map((item) => (
                <CartItem key={item.gericht.id} item={item} />
              ))}
            </Box>
          </Paper>
        </Grid>
        
        <Grid item xs={12} md={4}>
          <CartSummary onCheckout={handleNext} />
        </Grid>
      </Grid>
    );
  };
  
  const renderPickupStep = () => {
    return (
      <Grid container spacing={3}>
        <Grid item xs={12} md={8}>
          <PickupSelector />
        </Grid>
        
        <Grid item xs={12} md={4}>
          <CartSummary onCheckout={handleNext} />
        </Grid>
      </Grid>
    );
  };
  
  const renderConfirmationStep = () => {
    return (
      <Grid container spacing={3}>
        <Grid item xs={12} md={8}>
          <Paper sx={{ p: 3, mb: { xs: 3, md: 0 } }}>
            <Typography variant="h6" component="h2" gutterBottom>
              Bestellübersicht
            </Typography>
            
            <Box sx={{ mt: 2 }}>
              <Typography variant="subtitle1" gutterBottom>
                Abholung
              </Typography>
              <Typography variant="body1" paragraph>
                Datum: <strong>{abholDatum}</strong><br />
                Uhrzeit: <strong>{abholZeit} Uhr</strong>
              </Typography>
              
              {bemerkungen && (
                <>
                  <Typography variant="subtitle1" gutterBottom>
                    Bemerkungen
                  </Typography>
                  <Typography variant="body1" paragraph>
                    {bemerkungen}
                  </Typography>
                </>
              )}
              
              <Typography variant="subtitle1" gutterBottom>
                Bestellte Gerichte
              </Typography>
              {cartItems.map((item) => (
                <Box key={item.gericht.id} sx={{ mb: 2 }}>
                  <Grid container>
                    <Grid item xs={8}>
                      <Typography variant="body1">
                        {item.anzahl}× {item.gericht.name}
                      </Typography>
                    </Grid>
                    <Grid item xs={4} sx={{ textAlign: 'right' }}>
                      <Typography variant="body1">
                        CHF {(item.gericht.preis * item.anzahl).toFixed(2)}
                      </Typography>
                    </Grid>
                  </Grid>
                </Box>
              ))}
            </Box>
          </Paper>
        </Grid>
        
        <Grid item xs={12} md={4}>
          <CartSummary showCheckoutButton={false} />
          
          <Box sx={{ mt: 3 }}>
            <Button
              variant="contained"
              color="primary"
              fullWidth
              size="large"
              onClick={handleSubmitOrder}
              disabled={loading}
              startIcon={loading ? <CircularProgress size={20} color="inherit" /> : <PaymentIcon />}
              sx={{ py: 1.5 }}
            >
              {loading ? 'Wird verarbeitet...' : 'Jetzt bestellen und bezahlen'}
            </Button>
          </Box>
        </Grid>
      </Grid>
    );
  };
  
  return (
    <Box>
      <PageTitle title="Checkout" />
      
      <Stepper activeStep={activeStep} sx={{ mb: 4 }}>
        {steps.map((label) => (
          <Step key={label}>
            <StepLabel>{label}</StepLabel>
          </Step>
        ))}
      </Stepper>
      
      {renderStepContent(activeStep)}
      
      <Box sx={{ display: 'flex', justifyContent: 'space-between', mt: 4 }}>
        <Button
          variant="outlined"
          onClick={handleBack}
          disabled={activeStep === 0}
          sx={{ display: activeStep === 0 ? 'none' : 'inline-flex' }}
        >
          Zurück
        </Button>
        
        <Box sx={{ flex: '1 1 auto' }} />
        
        {activeStep < steps.length - 1 && cartItems.length > 0 && (
          <Button
            variant="contained"
            onClick={handleNext}
          >
            Weiter
          </Button>
        )}
      </Box>
    </Box>
  );
};

export default Checkout;
