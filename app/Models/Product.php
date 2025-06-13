<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Product extends Model
{
  
  
    use HasFactory;
    protected $fillable = ['category', 'title', 'description', 'About', 'price', 'discount', 'stock'];

    public function Category()
    {
        return $this->belongsTo(Category::class);
    }


    public function Images()
    {
         return $this->hasMany(ProductImage::class, 'product_id');
    }


    public function Cart()
    {
        return $this->hasMany(Cart::class);
    }

 public function showLatestProduct()
    {
        // هنا يتم استخدام الكود الخاص بك بشكل صحيح
        $latestProduct = Product::with('images') // تحميل الصور
                                ->orderBy('created_at', 'desc') // الترتيب
                                ->first(); // جلب أول نتيجة

        if ($latestProduct) {
            // إذا كنت تريد إرجاعها كـ JSON API response
            return response()->json($latestProduct);

            // أو إذا كنت تريد تمريرها إلى View
            // return view('products.latest', ['product' => $latestProduct]);
        } else {
            return response()->json(['message' => 'No products found'], 404);
        }
    }
}
