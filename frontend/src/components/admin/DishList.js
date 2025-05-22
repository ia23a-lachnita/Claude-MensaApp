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
  FilterList as FilterListIcon,
} from '@mui/icons-material';

const DishList = ({ dishes, onDelete }) => {
  const navigate = useNavigate();
  const [deleteDialogOpen, setDeleteDialogOpen] = useState(false);
  const [dishToDelete, setDishToDelete] = useState(null);
  const [searchTerm, setSearchTerm] = useState('');
  const [filterVegetarian, setFilterVegetarian] = useState(false);
  const [filterVegan, setFilterVegan] = useState(false);
  
  const handleEdit = (id) => {
    navigate(`/admin/dishes/${id}`);
  };
  
  const handleCreate = () => {
    navigate('/admin/dishes/new');
  };
  
  const handleOpenDeleteDialog = (dish) => {
    setDishToDelete(dish);
    setDeleteDialogOpen(true);
  };
  
  const handleCloseDeleteDialog = () => {
    setDeleteDialogOpen(false);
    setDishToDelete(null);
  };
  
  const handleDelete = () => {
    if (dishToDelete) {
      onDelete(dishToDelete.id);
    }
    handleCloseDeleteDialog();
  };
  
  const handleSearchChange = (event) => {
    setSearchTerm(event.target.value);
  };
  
  const toggleFilterVegetarian = () => {
    setFilterVegetarian(!filterVegetarian);
    if (!filterVegetarian) {
      setFilterVegan(false);
    }
  };
  
  const toggleFilterVegan = () => {
    setFilterVegan(!filterVegan);
    if (!filterVegan) {
      setFilterVegetarian(true);
    }
  };
  
  const filteredDishes = dishes.filter(dish => {
    const matchesSearch = dish.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
      (dish.beschreibung && dish.beschreibung.toLowerCase().includes(searchTerm.toLowerCase()));
    
    const matchesVegetarian = !filterVegetarian || dish.vegetarisch;
    const matchesVegan = !filterVegan || dish.vegan;
    
    return matchesSearch && matchesVegetarian && matchesVegan;
  });
  
  return (
    <>
      <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 3 }}>
        <Typography variant="h6" component="h2">
          Gerichte verwalten
        </Typography>
        
        <Button 
          variant="contained" 
          color="primary" 
          startIcon={<AddIcon />} 
          onClick={handleCreate}
        >
          Neues Gericht
        </Button>
      </Box>
      
      <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 3 }}>
        <TextField
          placeholder="Gerichte suchen..."
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
        
        <Box>
          <Chip
            label="Vegetarisch"
            clickable
            color={filterVegetarian ? 'success' : 'default'}
            onClick={toggleFilterVegetarian}
            sx={{ mr: 1 }}
          />
          <Chip
            label="Vegan"
            clickable
            color={filterVegan ? 'success' : 'default'}
            onClick={toggleFilterVegan}
          />
        </Box>
      </Box>
      
      <TableContainer component={Paper}>
        <Table sx={{ minWidth: 650 }}>
          <TableHead>
            <TableRow>
              <TableCell>ID</TableCell>
              <TableCell>Name</TableCell>
              <TableCell>Preis (CHF)</TableCell>
              <TableCell>Vegetarisch</TableCell>
              <TableCell>Vegan</TableCell>
              <TableCell align="right">Aktionen</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {filteredDishes.length > 0 ? (
              filteredDishes.map((dish) => (
                <TableRow key={dish.id}>
                  <TableCell>{dish.id}</TableCell>
                  <TableCell>{dish.name}</TableCell>
                  <TableCell>{dish.preis.toFixed(2)}</TableCell>
                  <TableCell>
                    {dish.vegetarisch ? 
                      <Chip label="Ja" size="small" color="success" /> : 
                      <Chip label="Nein" size="small" variant="outlined" />
                    }
                  </TableCell>
                  <TableCell>
                    {dish.vegan ? 
                      <Chip label="Ja" size="small" color="success" /> : 
                      <Chip label="Nein" size="small" variant="outlined" />
                    }
                  </TableCell>
                  <TableCell align="right">
                    <IconButton
                      color="primary"
                      onClick={() => handleEdit(dish.id)}
                      sx={{ mr: 1 }}
                    >
                      <EditIcon />
                    </IconButton>
                    <IconButton
                      color="error"
                      onClick={() => handleOpenDeleteDialog(dish)}
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
                    Keine Gerichte gefunden
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
        <DialogTitle>Gericht löschen</DialogTitle>
        <DialogContent>
          <DialogContentText>
            Möchten Sie das Gericht "{dishToDelete?.name}" wirklich löschen? Diese Aktion kann nicht rückgängig gemacht werden.
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

export default DishList;
