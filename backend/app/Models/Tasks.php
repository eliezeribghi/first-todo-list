<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Tasks extends Model
{
    //use HasFactory;


    public function category():BelongsTo
    {
        return $this->belongsTo(Category::class);
    }
}
