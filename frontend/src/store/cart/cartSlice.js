import { createSlice } from '@reduxjs/toolkit';

const initialState = {
  items: [],
  abholDatum: null,
  abholZeit: null,
  bemerkungen: '',
};

export const cartSlice = createSlice({
  name: 'cart',
  initialState,
  reducers: {
    addToCart: (state, action) => {
      const { gericht, anzahl } = action.payload;
      const existingItemIndex = state.items.findIndex(item => item.gericht.id === gericht.id);
      
      if (existingItemIndex !== -1) {
        // Wenn das Gericht bereits im Warenkorb ist, erhöhe die Anzahl
        state.items[existingItemIndex].anzahl += anzahl;
      } else {
        // Füge ein neues Gericht hinzu
        state.items.push({ gericht, anzahl });
      }
    },
    removeFromCart: (state, action) => {
      const gerichtId = action.payload;
      state.items = state.items.filter(item => item.gericht.id !== gerichtId);
    },
    updateCartItemQuantity: (state, action) => {
      const { gerichtId, anzahl } = action.payload;
      const existingItem = state.items.find(item => item.gericht.id === gerichtId);
      
      if (existingItem) {
        existingItem.anzahl = anzahl;
      }
    },
    setAbholDatum: (state, action) => {
      state.abholDatum = action.payload;
    },
    setAbholZeit: (state, action) => {
      state.abholZeit = action.payload;
    },
    setBemerkungen: (state, action) => {
      state.bemerkungen = action.payload;
    },
    clearCart: (state) => {
      state.items = [];
      state.abholDatum = null;
      state.abholZeit = null;
      state.bemerkungen = '';
    },
  },
});

export const {
  addToCart,
  removeFromCart,
  updateCartItemQuantity,
  setAbholDatum,
  setAbholZeit,
  setBemerkungen,
  clearCart,
} = cartSlice.actions;

// Selektoren
export const selectCartItems = (state) => state.cart.items;
export const selectCartItemsCount = (state) => state.cart.items.reduce((count, item) => count + item.anzahl, 0);
export const selectCartTotal = (state) => state.cart.items.reduce(
  (total, item) => total + (item.gericht.preis * item.anzahl), 0
);
export const selectAbholDatum = (state) => state.cart.abholDatum;
export const selectAbholZeit = (state) => state.cart.abholZeit;
export const selectBemerkungen = (state) => state.cart.bemerkungen;

export default cartSlice.reducer;
