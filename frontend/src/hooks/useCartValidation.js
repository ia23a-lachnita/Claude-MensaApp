import { useEffect, useCallback } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { 
  selectCartItems, 
  selectAbholDatum, 
  selectValidationErrors,
  setValidationErrors,
  clearValidationErrors 
} from '../store/cart/cartSlice';
import { basketService, convertCartToBasketRequest } from '../services/basketApi';

export const useCartValidation = () => {
  const dispatch = useDispatch();
  const cartItems = useSelector(selectCartItems);
  const abholDatum = useSelector(selectAbholDatum);
  const validationErrors = useSelector(selectValidationErrors);
  const cartState = useSelector(state => state.cart);

  const validateCart = useCallback(async () => {
    // Don't validate if cart is empty
    if (!cartItems || cartItems.length === 0) {
      dispatch(clearValidationErrors());
      return { valid: true };
    }

    try {
      const basketRequest = convertCartToBasketRequest(cartState);
      const validationResult = await basketService.validateBasket(basketRequest);
      
      if (validationResult.valid) {
        dispatch(clearValidationErrors());
      } else {
        dispatch(setValidationErrors(validationResult));
      }
      
      return validationResult;
    } catch (error) {
      console.error('Cart validation failed:', error);
      const errorResult = {
        valid: false,
        message: 'Fehler bei der Warenkorb-Validierung',
        hasConflictingDates: false,
        itemValidations: []
      };
      dispatch(setValidationErrors(errorResult));
      return errorResult;
    }
  }, [cartItems, cartState, dispatch]);

  // Auto-validate when pickup date changes
  useEffect(() => {
    if (abholDatum && cartItems.length > 0) {
      validateCart();
    }
  }, [abholDatum, validateCart]);

  return {
    validationErrors,
    validateCart,
    isValid: validationErrors.length === 0 || (validationErrors.valid !== false),
    hasConflictingDates: validationErrors.hasConflictingDates || false
  };
};