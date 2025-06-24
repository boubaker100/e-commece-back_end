<?php

namespace Database\Seeders;

use App\Models\Category;
use App\Models\Product;
use App\Models\ProductImage;
use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // إنشاء المستخدم الإداري إن لم يكن موجوداً
        $admin = User::firstOrCreate(
            ['email' => 'admin@gmail.com'],
            [
                'name' => 'admin',
                'role' => '1995',
                'password' => Hash::make('admin123$%'),
                'email_verified_at' => now(),
            ]
        );

        // إنشاء توكن للمستخدم الإداري
        if ($admin->tokens()->count() === 0) {
            $admin->createToken('admin-token');
        }

        // باقي البيانات العشوائية
        Category::factory(50)->create();
        Product::factory(100)->create();
        ProductImage::factory(400)->create();
    }
}
