import React from 'react';
import {
  Alert,
  AlertTitle,
  Box,
  Typography,
  Chip,
  List,
  ListItem,
  ListItemText,
  Divider,
  Button,
} from '@mui/material';
import { formatDate } from '../../utils/dateUtils';

const CartValidationDisplay = ({ validationErrors, onDateSuggestionClick }) => {
  if (!validationErrors || validationErrors.valid === true || validationErrors.length === 0) {
    return null;
  }

  const { 
    message, 
    hasConflictingDates, 
    dateConflicts, 
    itemValidations, 
    empfohlenesDatum, 
    moeglicheDaten 
  } = validationErrors;

  return (
    <Box sx={{ mb: 2 }}>
      {hasConflictingDates && dateConflicts && (
        <Alert severity="warning" sx={{ mb: 2 }}>
          <AlertTitle>Produktkonflikt</AlertTitle>
          <Typography variant="body2" gutterBottom>
            Ihre Produkte sind nur an verschiedenen Tagen verfügbar:
          </Typography>
          {dateConflicts.map((conflict, index) => (
            <Box key={index} sx={{ mt: 1 }}>
              <Typography variant="subtitle2" color="text.primary">
                {formatDate(conflict.datum)}:
              </Typography>
              <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 0.5, mt: 0.5 }}>
                {conflict.gerichtNamen.map((name, i) => (
                  <Chip key={i} label={name} size="small" variant="outlined" />
                ))}
              </Box>
            </Box>
          ))}
          <Typography variant="body2" sx={{ mt: 1 }}>
            Bitte entfernen Sie Produkte oder wählen Sie einen anderen Tag.
          </Typography>
        </Alert>
      )}

      {!hasConflictingDates && itemValidations && itemValidations.length > 0 && (
        <Alert severity="info" sx={{ mb: 2 }}>
          <AlertTitle>Produktverfügbarkeit</AlertTitle>
          <Typography variant="body2" gutterBottom>
            {message}
          </Typography>
          
          <List dense>
            {itemValidations
              .filter(item => !item.verfuegbarAmGewuenschtenDatum)
              .map((item, index) => (
                <ListItem key={index} sx={{ px: 0 }}>
                  <ListItemText
                    primary={item.gerichtName}
                    secondary={
                      item.alternativeDaten && item.alternativeDaten.length > 0 ? (
                        <Box>
                          <Typography variant="caption" display="block">
                            Verfügbar an:
                          </Typography>
                          <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 0.5, mt: 0.5 }}>
                            {item.alternativeDaten.slice(0, 3).map((date, i) => (
                              <Chip
                                key={i}
                                label={formatDate(date)}
                                size="small"
                                clickable
                                onClick={() => onDateSuggestionClick && onDateSuggestionClick(date)}
                                sx={{ cursor: 'pointer' }}
                              />
                            ))}
                            {item.alternativeDaten.length > 3 && (
                              <Typography variant="caption" sx={{ alignSelf: 'center' }}>
                                +{item.alternativeDaten.length - 3} weitere
                              </Typography>
                            )}
                          </Box>
                        </Box>
                      ) : (
                        "Nicht verfügbar"
                      )
                    }
                  />
                </ListItem>
              ))}
          </List>

          {empfohlenesDatum && (
            <Box sx={{ mt: 2 }}>
              <Divider sx={{ mb: 1 }} />
              <Typography variant="body2" gutterBottom>
                Empfohlenes Datum:
              </Typography>
              <Button
                variant="outlined"
                size="small"
                onClick={() => onDateSuggestionClick && onDateSuggestionClick(empfohlenesDatum)}
              >
                {formatDate(empfohlenesDatum)} wählen
              </Button>
            </Box>
          )}
        </Alert>
      )}

      {message && !hasConflictingDates && (!itemValidations || itemValidations.length === 0) && (
        <Alert severity="warning">
          <Typography variant="body2">{message}</Typography>
          {moeglicheDaten && moeglicheDaten.length > 0 && (
            <Box sx={{ mt: 1 }}>
              <Typography variant="caption" display="block" gutterBottom>
                Verfügbare Termine:
              </Typography>
              <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 0.5 }}>
                {moeglicheDaten.slice(0, 5).map((date, i) => (
                  <Chip
                    key={i}
                    label={formatDate(date)}
                    size="small"
                    clickable
                    onClick={() => onDateSuggestionClick && onDateSuggestionClick(date)}
                  />
                ))}
              </Box>
            </Box>
          )}
        </Alert>
      )}
    </Box>
  );
};

export default CartValidationDisplay;