JsOsaDAS1.001.00bplist00�Vscriptoo / * 
 	 e x p o r t   m a r k u p   t e x t   a s   H T M L   a n d   s a v e   i t   a s   a   f i l e 
 * / 
  
 v a r   a p p   =   A p p l i c a t i o n ( " T e x t S e r " ) ; 
 a p p . i n c l u d e S t a n d a r d A d d i t i o n s   =   t r u e ; 
 
 v a r   a r g   =   a p p . c u r r e n t D e s t i n a t i o n S c r i p t A r g u m e n t s ( ) ; 
 v a r   t i t   =   a p p . c u r r e n t T i t l e ( ) ;  v a r   t x t   =   a p p . c u r r e n t M a r k u p ( ) ; 
 
 v a r   l i n e s   =   t x t . s p l i t ( / \ n + / ) ; 
 v a r   r v   =   [ ] ; 
 f o r   ( v a r   i   =   0 ;   i   <   l i n e s . l e n g t h ;   i + + )   { 
 	 v a r   l i n e   =   l i n e s [ i ] ; 
 	 l i n e   =   l i n e . r e p l a c e ( / [   ] / g ,   ' " ' ) ; 
 	 
 	 i f   ( l i n e . c h a r A t ( 0 )   = = =   ' # ' )   { 
 	 	 l i n e   =   l i n e . r e p l a c e ( / ^ # + \ s + / ,   ' ' ) ; 
 	 	 l i n e   =   l i n e . t o U p p e r C a s e ( ) ; 
 	 	 r v . p u s h ( ' ' ) ; 
 	 	 r v . p u s h ( ' ' ) ; 
 	 	 r v . p u s h ( l i n e ) ; 
 	 } 
 	 e l s e   { 
 	 	 r v . p u s h ( l i n e ) ; 
 	 } 
 } 
 
 v a r   r e s u l t   =   r v . j o i n ( ' \ n ' ) ; 
 a p p . s e t T h e C l i p b o a r d T o ( r e s u l t ) ;                              �jscr  ��ޭ