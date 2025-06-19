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
import DrinkCartItem from '../components/cart/DrinkCartItem';
import CartSummary from '../components/cart/CartSummary';
import PickupSelector from '../components/cart/PickupSelector';
import EmptyState from '../components/common/EmptyState';
import { bestellungService } from '../services/api';
import {
  clearCart,
  selectCartItems,
  selectCartDrinks,
  selectCartTotal
} from '../store/cart/cartSlice';

const steps = ['Warenkorb', 'Abholzeit', 'Bestellübersicht'];

const Checkout = () => {
  const dispatch = useDispatch();
  const navigate = useNavigate();
  const cartItems = useSelector(selectCartItems);
  const cartDrinks = useSelector(selectCartDrinks);
  const cartTotal = useSelector(selectCartTotal);
  const abholDatum = useSelector(state => state.cart.abholDatum);
  const abholZeit = useSelector(state => state.cart.abholZeit);
  const bemerkungen = useSelector(state => state.cart.bemerkungen);

  const [activeStep, setActiveStep] = useState(0);
  const [loading, setLoading] = useState(false);

  // Calculate total items for easier checks
  const totalItems = cartItems.length + cartDrinks.length;
  const totalItemCount = cartItems.reduce((count, item) => count + item.anzahl, 0) +
      cartDrinks.reduce((count, item) => count + item.anzahl, 0);

  useEffect(() => {
    // Wenn der Warenkorb leer ist, zurück zum ersten Schritt navigieren
    if (totalItems === 0 && activeStep !== 0) {
      setActiveStep(0);
    }
  }, [cartItems, cartDrinks, activeStep, totalItems]);

  const handleNext = () => {
    const nextStep = activeStep + 1;

    // Validieren je nach aktuellem Schritt
    if (activeStep === 0 && totalItems === 0) {
      toast.error('Ihr Warenkorb ist leer. Bitte fügen Sie einige Gerichte oder Getränke hinzu.');
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
    if (totalItems === 0) {
      toast.error('Ihr Warenkorb ist leer');
      return;
    }

    setLoading(true);

    // Create order data with both dishes and drinks
    // Note: This assumes your backend can handle both gerichtId and getraenkId
    // You may need to modify your backend BestellPosition model to support both
    const orderData = {
      abholDatum,
      abholZeit,
      bemerkungen,
      positionen: [
        // Add dishes to positions
        ...cartItems.map(item => ({
          gerichtId: item.gericht.id,
          anzahl: item.anzahl,
          type: 'GERICHT' // Optional: to distinguish between dishes and drinks
        })),
        // Add drinks to positions
        // Note: You'll need to update your backend to handle drinks in positions
        // For now, this will create a structure that your backend needs to support
        ...cartDrinks.map(item => ({
          getraenkId: item.getraenk.id, // You'll need to add this field to BestellPosition
          anzahl: item.anzahl,
          type: 'GETRAENK' // Optional: to distinguish between dishes and drinks
        }))
      ]
    };

    try {
      const response = await bestellungService.createBestellung(orderData);
      dispatch(clearCart());
      navigate(`/payment/${response.data.id}`);
      toast.success('Bestellung erfolgreich erstellt!');
    } catch (error) {
      const message = error.response?.data?.message || 'Ein Fehler ist aufgetreten';
      toast.error(message);
      console.error('Order creation error:', error);
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
    if (totalItems === 0) {
      return (
          <EmptyState
              title="Ihr Warenkorb ist leer"
              message="Fügen Sie einige Gerichte oder Getränke aus dem Menü hinzu, um fortzufahren."
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
                Warenkorb ({totalItemCount} Artikel)
              </Typography>

              <Box sx={{ mt: 2 }}>
                {/* Display dishes */}
                {cartItems.length > 0 && (
                    <Box sx={{ mb: 3 }}>
                      <Typography variant="subtitle1" sx={{ mb: 2, fontWeight: 'bold' }}>
                        🍽️ Gerichte ({cartItems.reduce((count, item) => count + item.anzahl, 0)})
                      </Typography>
                      {cartItems.map((item) => (
                          <CartItem key={`dish-${item.gericht.id}`} item={item} />
                      ))}
                    </Box>
                )}

                {/* Display drinks */}
                {cartDrinks.length > 0 && (
                    <Box>
                      <Typography variant="subtitle1" sx={{ mb: 2, fontWeight: 'bold' }}>
                        🍹 Getränke ({cartDrinks.reduce((count, item) => count + item.anzahl, 0)})
                      </Typography>
                      {cartDrinks.map((item) => (
                          <DrinkCartItem key={`drink-${item.getraenk.id}`} item={item} />
                      ))}
                    </Box>
                )}
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
                  📅 Abholung
                </Typography>
                <Typography variant="body1" paragraph>
                  Datum: <strong>{abholDatum}</strong><br />
                  Uhrzeit: <strong>{abholZeit} Uhr</strong>
                </Typography>

                {bemerkungen && (
                    <>
                      <Typography variant="subtitle1" gutterBottom>
                        💬 Bemerkungen
                      </Typography>
                      <Typography variant="body1" paragraph>
                        {bemerkungen}
                      </Typography>
                    </>
                )}

                <Typography variant="subtitle1" gutterBottom>
                  🛒 Bestellte Artikel ({totalItemCount})
                </Typography>

                {/* Display ordered dishes */}
                {cartItems.length > 0 && (
                    <Box sx={{ mb: 2 }}>
                      <Typography variant="subtitle2" sx={{ mb: 1, color: 'primary.main' }}>
                        🍽️ Gerichte:
                      </Typography>
                      {cartItems.map((item) => (
                          <Box key={`checkout-dish-${item.gericht.id}`} sx={{ mb: 1, ml: 2 }}>
                            <Grid container>
                              <Grid item xs={8}>
                                <Typography variant="body1">
                                  {item.anzahl}× {item.gericht.name}
                                </Typography>
                                {item.gericht.vegetarisch && (
                                    <Typography variant="caption" color="success.main">
                                      Vegetarisch
                                    </Typography>
                                )}
                                {item.gericht.vegan && (
                                    <Typography variant="caption" color="success.main" sx={{ ml: 1 }}>
                                      Vegan
                                    </Typography>
                                )}
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
                )}

                {/* Display ordered drinks */}
                {cartDrinks.length > 0 && (
                    <Box sx={{ mb: 2 }}>
                      <Typography variant="subtitle2" sx={{ mb: 1, color: 'secondary.main' }}>
                        🍹 Getränke:
                      </Typography>
                      {cartDrinks.map((item) => (
                          <Box key={`checkout-drink-${item.getraenk.id}`} sx={{ mb: 1, ml: 2 }}>
                            <Grid container>
                              <Grid item xs={8}>
                                <Typography variant="body1">
                                  {item.anzahl}× {item.getraenk.name}
                                </Typography>
                                <Typography variant="caption" color="text.secondary">
                                  Getränk
                                </Typography>
                              </Grid>
                              <Grid item xs={4} sx={{ textAlign: 'right' }}>
                                <Typography variant="body1">
                                  CHF {(item.getraenk.preis * item.anzahl).toFixed(2)}
                                </Typography>
                              </Grid>
                            </Grid>
                          </Box>
                      ))}
                    </Box>
                )}

                {/* Order summary */}
                <Box sx={{
                  mt: 3,
                  pt: 2,
                  borderTop: 1,
                  borderColor: 'divider',
                  backgroundColor: 'grey.50',
                  borderRadius: 1,
                  p: 2
                }}>
                  <Grid container>
                    <Grid item xs={8}>
                      <Typography variant="h6">
                        Gesamtsumme:
                      </Typography>
                    </Grid>
                    <Grid item xs={4} sx={{ textAlign: 'right' }}>
                      <Typography variant="h6" color="primary.main">
                        CHF {cartTotal.toFixed(2)}
                      </Typography>
                    </Grid>
                  </Grid>
                </Box>
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

          {activeStep < steps.length - 1 && totalItems > 0 && (
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
