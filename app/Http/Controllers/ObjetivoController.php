<?php

namespace App\Http\Controllers;

use App\Models\Objetivo;
use Illuminate\Http\Request;

class ObjetivoController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $objetivo = Objetivo::all();
        return response()->json($objetivo, 200);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $request->validate(
            [
                'objetivo' => 'required|string',
                'descricao' => 'required|string',
                'concluido' => 'boolean',
                'arquivado' => 'boolean',
                'prioridade' => 'integer',
                'parent_id' => 'integer',
                'user_id' => 'required|exists:users,id',
            ]
        );

        $objetivo = Objetivo::create($request->all());

        return response()->json($objetivo, 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(Objetivo $objetivo)
    {
        $objetivo = Objetivo::find($objetivo);
        return response()->json($objetivo, 200);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Objetivo $objetivo)
    {
        $request->validate(
            [
                'objetivo' => 'required|string',
                'descricao' => 'required|string',
                'concluido' => 'boolean',
                'arquivado' => 'boolean',
                'prioridade' => 'integer',
                'parent_id' => 'integer',
                'user_id' => 'required|exists:users,id',
            ]
        );

        $objetivo->update($request->all());

        return response()->json($objetivo, 200);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Objetivo $objetivo)
    {
        $objetivo->delete();
        return response()->json(null, 204);
    }
}
