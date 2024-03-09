<?php

namespace App\Http\Controllers;

use App\Models\Objetivo;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rule;

class ObjetivoController extends Controller
{
    use SoftDeletes;
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

        Validator::extend('exists_or_zero', function ($attribute, $value, $parameters) {
            if ($value == 0) {
                return true;
            }
        
            $validator = Validator::make([$attribute => $value], [
                $attribute => Rule::exists($parameters[0], $parameters[1])
            ]);
        
            return !$validator->fails();
        });


        $regras = [
            'objetivo' => 'required|string',
            'descricao' => 'required|string',
            'concluido' => 'boolean',
            'arquivado' => 'boolean',
            'prioridade' => 'integer',
            'parent_id' => 'integer|exists_or_zero:objetivos,id',
            'user_id' => 'required|exists:users,id',
        ];

        $mensagens = [
            'objetivo.required' => 'O campo objetivo é obrigatório',
            'objetivo.string' => 'O campo objetivo deve ser uma string',
            'descricao.required' => 'O campo descrição é obrigatório',
            'descricao.string' => 'O campo descrição deve ser uma string',
            'concluido.boolean' => 'O campo concluído deve ser um boolean',
            'arquivado.boolean' => 'O campo arquivado deve ser um boolean',
            'prioridade.integer' => 'O campo prioridade deve ser um inteiro',
            'parent_id.integer' => 'O campo parent_id deve ser um inteiro',
            'parent_id.exists_or_zero' => 'O campo parent_id deve ser um id válido ou 0',
            'user_id.required' => 'O campo user_id é obrigatório',
            'user_id.exists' => 'O campo user_id deve ser um id válido',
            'parent_id.exists' => 'O campo parent_id deve ser um id válido',
        ];

        $request->validate($regras, $mensagens);

        $objetivo = Objetivo::create($request->all());

        return response()->json($objetivo, 201);
    }

    /**
     * Display the specified resource.
     */
    public function show($objetivo)
    {
        $objetivo = Objetivo::find($objetivo);

        if (!$objetivo) {
            return response()->json('Objetivo não encontrado', 404);
        }

        return response()->json($objetivo, 200);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $objetivo)
    {

        Validator::extend('exists_or_zero', function ($attribute, $value, $parameters) {
            if ($value == 0) {
                return true;
            }
        
            $validator = Validator::make([$attribute => $value], [
                $attribute => Rule::exists($parameters[0], $parameters[1])
            ]);
        
            return !$validator->fails();
        });

        $objetivo = Objetivo::find($objetivo);

        if (!$objetivo) {
            return response()->json('Objetivo não encontrado', 404);
        }

        $regras = [
            'objetivo' => 'string',
            'descricao' => 'string',
            'concluido' => 'boolean',
            'arquivado' => 'boolean',
            'prioridade' => 'integer',
            'parent_id' => 'integer|exists_or_zero:objetivos,id',
            'user_id' => 'exists:users,id',
        ];

        $mensagens = [
            'objetivo.string' => 'O campo objetivo deve ser uma string',
            'descricao.string' => 'O campo descrição deve ser uma string',
            'concluido.boolean' => 'O campo concluído deve ser um boolean',
            'arquivado.boolean' => 'O campo arquivado deve ser um boolean',
            'prioridade.integer' => 'O campo prioridade deve ser um inteiro',
            'parent_id.integer' => 'O campo parent_id deve ser um inteiro',
            'user_id.exists' => 'O campo user_id deve ser um id válido',
            'parent_id.exists_or_zero' => 'O campo parent_id deve ser um id válido ou 0',
        ];

        $request->validate($regras, $mensagens);

        $objetivo->update($request->all());

        return response()->json($objetivo, 200);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($objetivo)
    {
        $objetivo = Objetivo::withTrashed()->find($objetivo);

        if (!$objetivo) {
            return response()->json('Objetivo não encontrado', 404);
        }elseif ($objetivo->trashed()) {
            return response()->json('Objetivo já deletado', 200);
        }

        $objetivo->delete();
        
        if ($objetivo->trashed()) {
            return response()->json('Objetivo deletado com sucesso', 200);
        }
    }

    public function restore($objetivo)
    {
        $objetivo = Objetivo::withTrashed()->find($objetivo);

        if (!$objetivo) {
            return response()->json('Objetivo não encontrado', 404);
        }elseif (!$objetivo->trashed()) {
            return response()->json('Objetivo não deletado', 404);
        }

        $objetivo->restore();
        
        if (!$objetivo->trashed()) {
            return response()->json('Objetivo restaurado com sucesso', 200);
        }
    }

    public function forceDelete($objetivo)
    {
        $objetivo = Objetivo::withTrashed()->find($objetivo);

        if (!$objetivo) {
            return response()->json('Objetivo não encontrado', 404);
        }elseif (!$objetivo->trashed()) {
            return response()->json('Objetivo não deletado', 404);
        }

        $objetivo->forceDelete();
        return response()->json('Objetivo deletado permanentemente', 200);
    }

    public function conclusao($id)
    {
        $objetivo = Objetivo::find($id);

        if (!$objetivo) {
            return response()->json('Objetivo não encontrado', 404);
        }

        $objetivo->concluido = !$objetivo->concluido;
        $objetivo->save();

        return response()->json($objetivo, 200);
    }

    public function arquivar($id)
    {
        $objetivo = Objetivo::find($id);

        if (!$objetivo) {
            return response()->json('Objetivo não encontrado', 404);
        }

        $objetivo->arquivado = !$objetivo->arquivado;
        $objetivo->save();

        return response()->json($objetivo, 200);
    }

    public function prioridade($id, $n)
    {
        $objetivo = Objetivo::find($id);

        if (!$objetivo) {
            return response()->json('Objetivo não encontrado', 404);
        }

        $objetivo->prioridade = $n;
        $objetivo->save();

        return response()->json($objetivo, 200);
    }
}
