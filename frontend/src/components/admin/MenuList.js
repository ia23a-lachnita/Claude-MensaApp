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
  Dialog,
  DialogActions,
  DialogContent,
  DialogContentText,
  DialogTitle,
} from '@mui/material';
import {
  Edit as EditIcon,
  Delete as DeleteIcon,
  Add as AddIcon,
  Visibility as VisibilityIcon,
} from '@mui/icons-material';
import { formatDate } from '../../utils/dateUtils';
import { sortMenuPlansByDate } from '../../utils/menuUtils';

const MenuList = ({ menuPlans, onDelete }) => {
  const navigate = useNavigate();
  const [deleteDialogOpen, setDeleteDialogOpen] = useState(false);
  const [menuToDelete, setMenuToDelete] = useState(null);
  
  const handleEdit = (id) => {
    navigate(`/admin/menus/${id}`);
  };
  
  const handleCreate = () => {
    navigate('/admin/menus/new');
  };
  
  const handleOpenDeleteDialog = (menu) => {
    setMenuToDelete(menu);
    setDeleteDialogOpen(true);
  };
  
  const handleCloseDeleteDialog = () => {
    setDeleteDialogOpen(false);
    setMenuToDelete(null);
  };
  
  const handleDelete = () => {
    if (menuToDelete) {
      onDelete(menuToDelete.id);
    }
    handleCloseDeleteDialog();
  };
  
  return (
    <>
      <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 3 }}>
        <Typography variant="h6" component="h2">
          Menüpläne verwalten
        </Typography>
        
        <Button 
          variant="contained" 
          color="primary" 
          startIcon={<AddIcon />} 
          onClick={handleCreate}
        >
          Neuer Menüplan
        </Button>
      </Box>
      
      <TableContainer component={Paper}>
        <Table sx={{ minWidth: 650 }}>
          <TableHead>
            <TableRow>
              <TableCell>ID</TableCell>
              <TableCell>Datum</TableCell>
              <TableCell>Anzahl Gerichte</TableCell>
              <TableCell align="right">Aktionen</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {menuPlans.length > 0 ? (
              // Sortiere Menüpläne nach Datum (heute zuerst)
              sortMenuPlansByDate(menuPlans).map((menu) => (
                <TableRow key={menu.id}>
                  <TableCell>{menu.id}</TableCell>
                  <TableCell>{formatDate(menu.datum)}</TableCell>
                  <TableCell>{menu.gerichte.length}</TableCell>
                  <TableCell align="right">
                    <IconButton
                      color="info"
                      onClick={() => navigate(`/menu/${menu.datum}`)}
                      sx={{ mr: 1 }}
                    >
                      <VisibilityIcon />
                    </IconButton>
                    <IconButton
                      color="primary"
                      onClick={() => handleEdit(menu.id)}
                      sx={{ mr: 1 }}
                    >
                      <EditIcon />
                    </IconButton>
                    <IconButton
                      color="error"
                      onClick={() => handleOpenDeleteDialog(menu)}
                    >
                      <DeleteIcon />
                    </IconButton>
                  </TableCell>
                </TableRow>
              ))
            ) : (
              <TableRow>
                <TableCell colSpan={4} align="center">
                  <Typography variant="body1" sx={{ py: 2 }}>
                    Keine Menüpläne gefunden
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
        <DialogTitle>Menüplan löschen</DialogTitle>
        <DialogContent>
          <DialogContentText>
            Möchten Sie den Menüplan für den {menuToDelete && formatDate(menuToDelete.datum)} wirklich löschen? Diese Aktion kann nicht rückgängig gemacht werden.
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

export default MenuList;
