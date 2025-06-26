<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
         \Log::info('Login Attempt Received', request()->all());
          // توليد مفاتيح Passport تلقائيًا إذا كانت البيئة production
        if (app()->environment('production')) {
            try {
                Artisan::call('passport:keys', ['--force' => true]);
                Log::info('Passport keys generated successfully');
            } catch (\Exception $e) {
                Log::error('Passport key generation failed: ' . $e->getMessage());
            }
        }

    }
}
