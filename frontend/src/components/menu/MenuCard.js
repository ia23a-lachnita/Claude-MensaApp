import React from 'react';
import { useNavigate } from 'react-router-dom';
import {
  Card,
  CardContent,
  CardActions,
  Typography,
  Button,
  Box,
  Chip,
  Divider,
  Grid,
} from '@mui/material';
import {
  Restaurant as RestaurantIcon,
  LocalBar as LocalBarIcon
} from '@mui/icons-material';
import { formatDate } from '../../utils/dateUtils';

const MenuCard = ({ menuplan, compact = false }) => {
  const navigate = useNavigate();

  const { id, datum, gerichte, getraenke } = menuplan;

  const handleViewDetails = () => {
    navigate(`/menu/${datum}`);
  };

  return (
      <Card
          elevation={3}
          sx={{
            height: compact ? 'auto' : '100%',
            display: 'flex',
            flexDirection: 'column',
            transition: 'transform 0.2s',
            '&:hover': {
              transform: 'translateY(-4px)',
            },
          }}
      >
        <CardContent sx={{ flexGrow: 1 }}>
          <Typography variant={compact ? 'h6' : 'h5'} component="h2" gutterBottom>
            Menü für {formatDate(datum)}
          </Typography>

          <Divider sx={{ my: 1.5 }} />

          {compact ? (
              <Box>
                <Box sx={{ display: 'flex', alignItems: 'center', mb: 1 }}>
                  <RestaurantIcon sx={{ mr: 1, fontSize: 'small' }} />
                  <Typography variant="body2" color="text.secondary">
                    {gerichte?.length || 0} Gerichte
                  </Typography>
                </Box>
                {getraenke && getraenke.length > 0 && (
                    <Box sx={{ display: 'flex', alignItems: 'center' }}>
                      <LocalBarIcon sx={{ mr: 1, fontSize: 'small' }} />
                      <Typography variant="body2" color="text.secondary">
                        {getraenke.length} Getränke
                      </Typography>
                    </Box>
                )}
              </Box>
          ) : (
              <Box sx={{ mt: 2 }}>
                {/* Display Dishes */}
                {gerichte && gerichte.length > 0 && (
                    <Box sx={{ mb: 2 }}>
                      <Box sx={{ display: 'flex', alignItems: 'center', mb: 1 }}>
                        <RestaurantIcon sx={{ mr: 1, color: 'primary.main' }} />
                        <Typography variant="subtitle1" color="primary.main">
                          Gerichte
                        </Typography>
                      </Box>
                      {gerichte.slice(0, 3).map((gericht) => (
                          <Box key={gericht.id} sx={{ mb: 2, ml: 2 }}>
                            <Grid container spacing={1} alignItems="center">
                              <Grid item xs>
                                <Typography variant="subtitle2" component="div">
                                  {gericht.name}
                                </Typography>
                              </Grid>
                              <Grid item>
                                <Typography variant="subtitle2" component="div" color="primary.main">
                                  CHF {gericht.preis.toFixed(2)}
                                </Typography>
                              </Grid>
                            </Grid>

                            <Typography variant="body2" color="text.secondary" sx={{ mt: 0.5, ml: 0 }}>
                              {gericht.beschreibung && gericht.beschreibung.length > 50
                                  ? `${gericht.beschreibung.substring(0, 50)}...`
                                  : gericht.beschreibung}
                            </Typography>

                            <Box sx={{ mt: 1 }}>
                              {gericht.vegetarisch && (
                                  <Chip
                                      label="Vegetarisch"
                                      size="small"
                                      color="success"
                                      variant="outlined"
                                      sx={{ mr: 0.5, mb: 0.5 }}
                                  />
                              )}
                              {gericht.vegan && (
                                  <Chip
                                      label="Vegan"
                                      size="small"
                                      color="success"
                                      sx={{ mr: 0.5, mb: 0.5 }}
                                  />
                              )}
                            </Box>
                          </Box>
                      ))}

                      {gerichte.length > 3 && (
                          <Typography variant="body2" color="text.secondary" sx={{ ml: 2 }}>
                            +{gerichte.length - 3} weitere Gerichte
                          </Typography>
                      )}
                    </Box>
                )}

                {/* Display Drinks */}
                {getraenke && getraenke.length > 0 && (
                    <Box>
                      <Box sx={{ display: 'flex', alignItems: 'center', mb: 1 }}>
                        <LocalBarIcon sx={{ mr: 1, color: 'secondary.main' }} />
                        <Typography variant="subtitle1" color="secondary.main">
                          Getränke
                        </Typography>
                      </Box>
                      {getraenke.slice(0, 3).map((getraenk) => (
                          <Box key={getraenk.id} sx={{ mb: 1, ml: 2 }}>
                            <Grid container spacing={1} alignItems="center">
                              <Grid item xs>
                                <Typography variant="body2" component="div">
                                  {getraenk.name}
                                </Typography>
                              </Grid>
                              <Grid item>
                                <Typography variant="body2" component="div" color="secondary.main">
                                  CHF {getraenk.preis.toFixed(2)}
                                </Typography>
                              </Grid>
                            </Grid>
                            {getraenk.beschreibung && (
                                <Typography variant="caption" color="text.secondary" sx={{ ml: 0 }}>
                                  {getraenk.beschreibung}
                                </Typography>
                            )}
                          </Box>
                      ))}

                      {getraenke.length > 3 && (
                          <Typography variant="body2" color="text.secondary" sx={{ ml: 2 }}>
                            +{getraenke.length - 3} weitere Getränke
                          </Typography>
                      )}
                    </Box>
                )}
              </Box>
          )}
        </CardContent>
        <CardActions>
          <Button
              size="small"
              onClick={handleViewDetails}
              sx={{ ml: 1, mb: 1 }}
          >
            Details ansehen
          </Button>
        </CardActions>
      </Card>
  );
};

export default MenuCard;
