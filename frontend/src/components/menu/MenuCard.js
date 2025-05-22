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
import { formatDate } from '../../utils/dateUtils';

const MenuCard = ({ menuplan, compact = false }) => {
  const navigate = useNavigate();
  
  const { id, datum, gerichte } = menuplan;
  
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
          <Typography variant="body2" color="text.secondary">
            {gerichte.length} Gerichte verfügbar
          </Typography>
        ) : (
          <Box sx={{ mt: 2 }}>
            {gerichte.slice(0, 3).map((gericht) => (
              <Box key={gericht.id} sx={{ mb: 2 }}>
                <Grid container spacing={1} alignItems="center">
                  <Grid item xs>
                    <Typography variant="subtitle1" component="div">
                      {gericht.name}
                    </Typography>
                  </Grid>
                  <Grid item>
                    <Typography variant="subtitle1" component="div" color="primary.main">
                      CHF {gericht.preis.toFixed(2)}
                    </Typography>
                  </Grid>
                </Grid>
                
                <Typography variant="body2" color="text.secondary" sx={{ mt: 0.5 }}>
                  {gericht.beschreibung && gericht.beschreibung.length > 60
                    ? `${gericht.beschreibung.substring(0, 60)}...`
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
              <Typography variant="body2" color="text.secondary">
                +{gerichte.length - 3} weitere Gerichte
              </Typography>
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
