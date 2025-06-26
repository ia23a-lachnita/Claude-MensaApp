import { createSlice } from '@reduxjs/toolkit';

const initialState = {
  items: [], // For dishes
  drinks: [], // For drinks
  abholDatum: null,
  abholZeit: null,
  bemerkungen: '',
  originalMenuDate: null, // Track the date from which first product was added
  validationErrors: [], // Store real-time validation errors
};

export const cartSlice = createSlice({
  name: 'cart',
  initialState,
  reducers: {
    addToCart: (state, action) => {
      const { gericht, anzahl, menuDate } = action.payload;
      const existingItemIndex = state.items.findIndex(item => item.gericht.id === gericht.id);

      // Set original menu date if this is the first item and no date is set
      if (state.items.length === 0 && state.drinks.length === 0 && menuDate && !state.originalMenuDate) {
        state.originalMenuDate = menuDate;
        // Auto-set pickup date to the original menu date
        if (!state.abholDatum) {
          state.abholDatum = menuDate;
        }
      }

      if (existingItemIndex !== -1) {
        state.items[existingItemIndex].anzahl += anzahl;
      } else {
        state.items.push({ gericht, anzahl, originalMenuDate: menuDate });
      }
    },

    // NEW: Add drinks to cart
    addDrinkToCart: (state, action) => {
      const { getraenk, anzahl } = action.payload;
      // Ensure drinks array exists
      if (!state.drinks) {
        state.drinks = [];
      }
      const existingDrinkIndex = state.drinks.findIndex(item => item.getraenk.id === getraenk.id);

      if (existingDrinkIndex !== -1) {
        state.drinks[existingDrinkIndex].anzahl += anzahl;
      } else {
        state.drinks.push({ getraenk, anzahl });
      }
    },

    removeFromCart: (state, action) => {
      const gerichtId = action.payload;
      state.items = state.items.filter(item => item.gericht.id !== gerichtId);
    },

    // NEW: Remove drinks from cart
    removeDrinkFromCart: (state, action) => {
      const getraenkId = action.payload;
      // Ensure drinks array exists
      if (!state.drinks) {
        state.drinks = [];
      }
      state.drinks = state.drinks.filter(item => item.getraenk.id !== getraenkId);
    },

    updateCartItemQuantity: (state, action) => {
      const { gerichtId, anzahl } = action.payload;
      const existingItem = state.items.find(item => item.gericht.id === gerichtId);

      if (existingItem) {
        existingItem.anzahl = anzahl;
      }
    },

    // NEW: Update drink quantity
    updateCartDrinkQuantity: (state, action) => {
      const { getraenkId, anzahl } = action.payload;
      // Ensure drinks array exists
      if (!state.drinks) {
        state.drinks = [];
      }
      const existingDrink = state.drinks.find(item => item.getraenk.id === getraenkId);

      if (existingDrink) {
        existingDrink.anzahl = anzahl;
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
      state.drinks = [];
      state.abholDatum = null;
      state.abholZeit = null;
      state.bemerkungen = '';
      state.originalMenuDate = null;
      state.validationErrors = [];
    },
    setValidationErrors: (state, action) => {
      state.validationErrors = action.payload;
    },
    clearValidationErrors: (state) => {
      state.validationErrors = [];
    },
  },
});

export const {
  addToCart,
  addDrinkToCart,
  removeFromCart,
  removeDrinkFromCart,
  updateCartItemQuantity,
  updateCartDrinkQuantity,
  setAbholDatum,
  setAbholZeit,
  setBemerkungen,
  clearCart,
  setValidationErrors,
  clearValidationErrors,
} = cartSlice.actions;

// Updated and SAFE selectors
export const selectCartItems = (state) => state.cart.items || [];
export const selectCartDrinks = (state) => state.cart.drinks || [];

export const selectCartItemsCount = (state) => {
  const items = state.cart.items || [];
  const drinks = state.cart.drinks || [];
  return items.reduce((count, item) => count + item.anzahl, 0) +
      drinks.reduce((count, item) => count + item.anzahl, 0);
};

export const selectCartTotal = (state) => {
  const items = state.cart.items || [];
  const drinks = state.cart.drinks || [];
  return items.reduce((total, item) => total + (item.gericht.preis * item.anzahl), 0) +
      drinks.reduce((total, item) => total + (item.getraenk.preis * item.anzahl), 0);
};

export const selectAbholDatum = (state) => state.cart.abholDatum;
export const selectAbholZeit = (state) => state.cart.abholZeit;
export const selectBemerkungen = (state) => state.cart.bemerkungen;
export const selectOriginalMenuDate = (state) => state.cart.originalMenuDate;
export const selectValidationErrors = (state) => state.cart.validationErrors || [];

export default cartSlice.reducer;
