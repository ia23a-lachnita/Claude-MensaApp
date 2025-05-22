import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import {
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Paper,
  Button,
  IconButton,
  Box,
  Typography,
  Chip,
  Dialog,
  DialogActions,
  DialogContent,
  DialogContentText,
  DialogTitle,
  TextField,
  InputAdornment,
} from '@mui/material';
import {
  Edit as EditIcon,
  Delete as DeleteIcon,
  Add as AddIcon,
  Search as SearchIcon,
} from '@mui/icons-material';

const DrinkList = ({ drinks, onDelete }) => {
  const navigate = useNavigate();
  const [deleteDialogOpen, setDeleteDialogOpen] = useState(false);
  const [drinkToDelete, setDrinkToDelete] = useState(null);
  const [searchTerm, setSearchTerm] = useState('');
  
  const handleEdit = (id) => {
    navigate(`/admin/drinks/${id}`);
  };
  
  const handleCreate = () => {
    navigate('/admin/drinks/new');
  };
  
  const handleOpenDeleteDialog = (drink) => {
    setDrinkToDelete(drink);
    setDeleteDialogOpen(true);
  };
  
  const handleCloseDeleteDialog = () => {
    setDeleteDialogOpen(false);
    setDrinkToDelete(null);
  };
  
  const handleDelete = () => {
    if (drinkToDelete) {
      onDelete(drinkToDelete.id);
    }
    handleCloseDeleteDialog();
  };
  
  const handleSearchChange = (event) => {
    setSearchTerm(event.target.value);
  };
  
  const filteredDrinks = drinks.filter(drink => {
    return drink.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
      (drink.beschreibung && drink.beschreibung.toLowerCase().includes(searchTerm.toLowerCase()));
  });
  
  return (
    <>
      <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 3 }}>
        <Typography variant="h6" component="h2">
          Getränke verwalten
        </Typography>
        
        <Button 
          variant="contained" 
          color="primary" 
          startIcon={<AddIcon />} 
          onClick={handleCreate}
        >
          Neues Getränk
        </Button>
      </Box>
      
      <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 3 }}>
        <TextField
          placeholder="Getränke suchen..."
          variant="outlined"
          size="small"
          value={searchTerm}
          onChange={handleSearchChange}
          sx={{ width: '40%' }}
          InputProps={{
            startAdornment: (
              <InputAdornment position="start">
                <SearchIcon />
              </InputAdornment>
            ),
          }}
        />
      </Box>
      
      <TableContainer component={Paper}>
        <Table sx={{ minWidth: 650 }}>
          <TableHead>
            <TableRow>
              <TableCell>ID</TableCell>
              <TableCell>Name</TableCell>
              <TableCell>Preis (CHF)</TableCell>
              <TableCell>Vorrat</TableCell>
              <TableCell>Verfügbar</TableCell>
              <TableCell align="right">Aktionen</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {filteredDrinks.length > 0 ? (
              filteredDrinks.map((drink) => (
                <TableRow key={drink.id}>
                  <TableCell>{drink.id}</TableCell>
                  <TableCell>{drink.name}</TableCell>
                  <TableCell>{drink.preis.toFixed(2)}</TableCell>
                  <TableCell>{drink.vorrat}</TableCell>
                  <TableCell>
                    {drink.verfuegbar ? 
                      <Chip label="Ja" size="small" color="success" /> : 
                      <Chip label="Nein" size="small" color="error" />
                    }
                  </TableCell>
                  <TableCell align="right">
                    <IconButton
                      color="primary"
                      onClick={() => handleEdit(drink.id)}
                      sx={{ mr: 1 }}
                    >
                      <EditIcon />
                    </IconButton>
                    <IconButton
                      color="error"
                      onClick={() => handleOpenDeleteDialog(drink)}
                    >
                      <DeleteIcon />
                    </IconButton>
                  </TableCell>
                </TableRow>
              ))
            ) : (
              <TableRow>
                <TableCell colSpan={6} align="center">
                  <Typography variant="body1" sx={{ py: 2 }}>
                    Keine Getränke gefunden
                  </Typography>
                </TableCell>
              </TableRow>
            )}
          </TableBody>
        </Table>
      </TableContainer>
      
      <Dialog
        open={deleteDialogOpen}
        onClose={handleCloseDeleteDialog}
      >
        <DialogTitle>Getränk löschen</DialogTitle>
        <DialogContent>
          <DialogContentText>
            Möchten Sie das Getränk "{drinkToDelete?.name}" wirklich löschen? Diese Aktion kann nicht rückgängig gemacht werden.
          </DialogContentText>
        </DialogContent>
        <DialogActions>
          <Button onClick={handleCloseDeleteDialog}>Abbrechen</Button>
          <Button onClick={handleDelete} color="error" variant="contained">
            Löschen
          </Button>
        </DialogActions>
      </Dialog>
    </>
  );
};

export default DrinkList;
