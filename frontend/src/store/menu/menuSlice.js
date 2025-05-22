import { createSlice } from '@reduxjs/toolkit';

const initialState = {
  menuplan: null,
  weeklyMenus: [],
  dishes: [],
  selectedDate: null,
  loading: false,
  error: null,
};

export const menuSlice = createSlice({
  name: 'menu',
  initialState,
  reducers: {
    fetchMenuStart: (state) => {
      state.loading = true;
      state.error = null;
    },
    fetchMenuSuccess: (state, action) => {
      state.menuplan = action.payload;
      state.loading = false;
      state.error = null;
    },
    fetchWeeklyMenusSuccess: (state, action) => {
      state.weeklyMenus = action.payload;
      state.loading = false;
      state.error = null;
    },
    fetchDishesSuccess: (state, action) => {
      state.dishes = action.payload;
      state.loading = false;
      state.error = null;
    },
    fetchMenuError: (state, action) => {
      state.loading = false;
      state.error = action.payload;
    },
    setSelectedDate: (state, action) => {
      state.selectedDate = action.payload;
    },
    clearMenus: (state) => {
      state.menuplan = null;
      state.weeklyMenus = [];
      state.dishes = [];
      state.selectedDate = null;
    },
  },
});

export const {
  fetchMenuStart,
  fetchMenuSuccess,
  fetchWeeklyMenusSuccess,
  fetchDishesSuccess,
  fetchMenuError,
  setSelectedDate,
  clearMenus,
} = menuSlice.actions;

export default menuSlice.reducer;
