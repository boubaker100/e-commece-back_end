<?php

namespace App\Http\Controllers;

use Illuminate\Foundation\Auth\Access\AuthorizesRequests;
use Illuminate\Foundation\Validation\ValidatesRequests;
use Illuminate\Routing\Controller as BaseController;
  // أو App\Models\Product أو App\Models\ProductImage حسب النموذج الذي تعدله
 

class Controller extends BaseController
{
    use AuthorizesRequests, ValidatesRequests;

   
 
}